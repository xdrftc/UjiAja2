// lib/screen/auth/loginsiswa.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/siswa/homescreen_siswa/homescreenSiswa.dart';

final supabase = Supabase.instance.client;

class LoginSiswa extends StatefulWidget {
  const LoginSiswa({super.key});
  @override
  State<LoginSiswa> createState() => _LoginSiswaState();
}

class _LoginSiswaState extends State<LoginSiswa> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedJurusan;
  String? _selectedKelas;
  bool _isLoading = false;
  bool _isLoadingDropdown = false;

  List<Map<String, dynamic>> _jurusanList = [];
  List<Map<String, dynamic>> _kelasList = [];

  @override
  void initState() {
    super.initState();
    _loadJurusan();
  }

  Future<void> _loadJurusan() async {
    setState(() => _isLoadingDropdown = true);
    try {
      final res = await supabase
          .from('jurusan')
          .select('id, nama')
          .order('nama');
      setState(() {
        _jurusanList = List<Map<String, dynamic>>.from(res);
        _isLoadingDropdown = false;
      });
    } catch (e) {
      _showSnackBar("Gagal load jurusan: $e");
      setState(() => _isLoadingDropdown = false);
    }
  }

  Future<void> _loadKelas(String jurusanId) async {
    setState(() => _isLoadingDropdown = true);
    try {
      final res = await supabase
          .from('kelas')
          .select('id, nama')
          .eq('jurusan_id', jurusanId)
          .order('nama');
      setState(() {
        _kelasList = List<Map<String, dynamic>>.from(res);
        _selectedKelas = null;
        _isLoadingDropdown = false;
      });
    } catch (e) {
      _showSnackBar("Gagal load kelas: $e");
      setState(() => _isLoadingDropdown = false);
    }
  }

  // ========== FUNGSI UTAMA: LOGIN OR REGISTER ==========
  Future<void> _loginOrRegister() async {
    final nama = _namaController.text.trim();
    final nisn = _nisnController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // VALIDASI
    if (nama.isEmpty ||
        nisn.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _selectedJurusan == null ||
        _selectedKelas == null) {
      _showSnackBar("Semua field harus diisi!");
      return;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(nisn)) {
      _showSnackBar("NISN harus 10 digit angka!");
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showSnackBar("Email tidak valid!");
      return;
    }
    if (password.length < 6) {
      _showSnackBar("Password minimal 6 karakter!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("1. Cek NISN: $nisn di tabel siswa");
      final siswaRes = await supabase
          .from('siswa')
          .select('nama, email')
          .eq('nisn', nisn)
          .maybeSingle();

      if (siswaRes != null) {
        // NISN ADA → HARUS LOGIN
        final data = siswaRes as Map<String, dynamic>;
        if (data['nama'].toString().toLowerCase() != nama.toLowerCase() ||
            data['email'] != email) {
          _showSnackBar("Data NISN tidak cocok!");
          return;
        }

        try {
          await supabase.auth.signInWithPassword(
            email: email,
            password: password,
          );
          _showSnackBar("Login berhasil!");
        } on AuthException catch (e) {
          _showSnackBar("Password salah!");
          return;
        }
      } else {
        // NISN BELUM ADA → CEK EMAIL SUDAH TERDAFTAR?
        print("2. Cek email: $email");
        try {
          await supabase.auth.signInWithPassword(
            email: email,
            password: "dummy",
          );
          _showSnackBar("Email sudah terdaftar! Gunakan email lain.");
          return;
        } on AuthException catch (e) {
          if (e.message.contains('Invalid login credentials')) {
            // EMAIL BELUM ADA → BUAT AKUN + INSERT SISWA
            print("   → Buat akun baru + insert siswa");

            // 1. SIGNUP
            final signUpResp = await supabase.auth.signUp(
              email: email,
              password: password,
            );

            if (signUpResp.user == null) {
              _showSnackBar("Gagal buat akun!");
              return;
            }

            // 2. INSERT LANGSUNG KE TABEL SISWA
            // DAPATKAN ID JURUSAN (uuid) DARI NAMA YANG DIPILIH
            final jurusanData = _jurusanList.firstWhere(
              (j) => j['nama'] == _selectedJurusan,
              orElse: () => throw "Jurusan tidak ditemukan!",
            );
            final String jurusanId = jurusanData['id'] as String;

            // INSERT KE TABEL SISWA — jurusan PAKAI ID (uuid)!
            await supabase
                .from('siswa')
                .insert({
                  'nisn': nisn,
                  'nama': nama,
                  'email': email,
                  'kelas': _selectedKelas, // ini string, tetap
                  'jurusan': jurusanId, // ← INI YANG BENAR: uuid, bukan nama!
                  'role': 'siswa',
                })
                .onError((error, stackTrace) {
                  debugPrint("GAGAL INSERT SISWA: $error");
                  _showSnackBar("Gagal simpan data siswa: $error");
                  return Future.error(error!);
                });

            _showSnackBar("Akun & data siswa berhasil dibuat!");
          } else {
            _showSnackBar("Error: ${e.message}");
            return;
          }
        }
      }

      // MASUK HOME
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e, s) {
      print("ERROR: $e\n$s");
      _showSnackBar("Kesalahan: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg) {
    _scaffoldKey.currentState?.hideCurrentSnackBar();
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: msg.contains('berhasil') || msg.contains('dibuat')
            ? Colors.green
            : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).size.height * 0.08,
                24,
                40,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    "UJIAJA",
                    style: TextStyle(
                      fontFamily: "LeckerliOne",
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Masukkan data Anda. Jika belum terdaftar, akun akan dibuat otomatis.",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // FORM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        "Login Siswa",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF126998),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField("Nama", _namaController),
                      const SizedBox(height: 16),
                      _buildTextField(
                        "NISN",
                        _nisnController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        "Jurusan",
                        _selectedJurusan,
                        _jurusanList.map((j) => j['nama'] as String).toList(),
                        (val) {
                          setState(() => _selectedJurusan = val);
                          final jurusan = _jurusanList.firstWhere(
                            (j) => j['nama'] == val,
                          );
                          _loadKelas(jurusan['id']);
                        },
                        hint: _isLoadingDropdown
                            ? "Memuat..."
                            : "Pilih Jurusan",
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        "Kelas",
                        _selectedKelas,
                        _kelasList.map((k) => k['nama'] as String).toList(),
                        (val) => setState(() => _selectedKelas = val),
                        enabled: _kelasList.isNotEmpty,
                        hint: _isLoadingDropdown ? "Memuat..." : "Pilih Kelas",
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        "Email",
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        "Password",
                        _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF126998),
                            )
                          : ElevatedButton(
                              onPressed: _loginOrRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF126998),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 60,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF1EAFFE)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    bool enabled = true,
    String? hint,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(
        hint ?? "Pilih $label",
        style: const TextStyle(color: Colors.grey),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF1EAFFE)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE), width: 2),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}
