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
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); // BARU: PASSWORD
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
      final response = await supabase
          .from('jurusan')
          .select('id, nama')
          .order('nama');
      setState(() {
        _jurusanList = List<Map<String, dynamic>>.from(response);
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
      final response = await supabase
          .from('kelas')
          .select('id, nama')
          .eq('jurusan_id', jurusanId)
          .order('nama');
      setState(() {
        _kelasList = List<Map<String, dynamic>>.from(response);
        _selectedKelas = null;
        _isLoadingDropdown = false;
      });
    } catch (e) {
      _showSnackBar("Gagal load kelas: $e");
      setState(() => _isLoadingDropdown = false);
    }
  }

  Future<void> _loginOrRegister() async {
    final nama = _namaController.text.trim();
    final nisn = _nisnController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim(); // AMBIL PASSWORD

    if (nama.isEmpty ||
        nisn.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _selectedJurusan == null ||
        _selectedKelas == null) {
      _showSnackBar("Semua field harus diisi");
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(nisn)) {
      _showSnackBar("NISN harus 10 digit angka");
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showSnackBar("Email tidak valid");
      return;
    }

    if (password.length < 6) {
      _showSnackBar("Password minimal 6 karakter");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final existing = await supabase
          .from('siswa')
          .select()
          .eq('nisn', nisn)
          .maybeSingle();

      if (existing != null) {
        final data = existing as Map;
        if (data['nama'].toString().toLowerCase() != nama.toLowerCase()) {
          _showSnackBar("Nama tidak sesuai dengan NISN");
          return;
        }
        if (data['email'] != email) {
          _showSnackBar("Email tidak sesuai dengan NISN");
          return;
        }
      }

      try {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        _showSnackBar("Login berhasil!");
      } on AuthException catch (e) {
        if (e.message.contains('Invalid login credentials')) {
          await supabase.auth.signUp(email: email, password: password);
          await supabase.from('siswa').insert({
            'nisn': nisn,
            'nama': nama,
            'email': email,
            'kelas': _selectedKelas,
            'jurusan': _selectedJurusan,
            'role': 'siswa',
          });
          _showSnackBar("Akun baru dibuat otomatis!");
        } else {
          rethrow;
        }
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nisnController.dispose();
    _emailController.dispose();
    _passwordController.dispose(); // TAMBAH!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER BIRU
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24, size.height * 0.08, 24, 40),
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
              child: Column(
                children: [
                  Text(
                    "UJIAJA",
                    style: TextStyle(
                      fontFamily: "LeckerliOne",
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Silakan login menggunakan nama lengkap dan NIS.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // FORM CARD
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
                      Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF126998),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildTextField("Nama", _namaController),
                      const SizedBox(height: 16),
                      _buildTextField(
                        "Nisn",
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
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ), // BARU!
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
    bool obscureText = false, // BARU: UNTUK PASSWORD
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText, // Sembunyikan teks untuk password
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
