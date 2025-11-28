import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ujiaja/screen/siswa/homescreen_siswa/daftarjurusan.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  bool _isLoading = false;

  // ==================== LOGIN TANPA CLOUD FUNCTION ====================
  Future<void> _login() async {
    final nama = _namaController.text.trim();
    final nisn = _nisnController.text.trim();

    if (nama.isEmpty || nisn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan NISN harus diisi")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firestore = FirebaseFirestore.instance;

      // 1. Cek apakah NISN sudah terdaftar
      final doc = await firestore.collection('siswa').doc(nisn).get();

      if (doc.exists) {
        final data = doc.data()!;
        if (data['nama'].toString().toLowerCase() != nama.toLowerCase()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Nama tidak sesuai dengan NISN")),
          );
          setState(() => _isLoading = false);
          return;
        }
      } else {
        // 2. Daftar otomatis jika belum ada
        await firestore.collection('siswa').doc(nisn).set({
          'nama': nama,
          'nisn': nisn,
          'role': 'siswa',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 3. Login pakai Anonymous + Simpan NISN sebagai UID
      final authResult = await FirebaseAuth.instance.signInAnonymously();
      final user = authResult.user!;

      // Simpan NISN di Firestore (bukan di Auth UID)
      await firestore.collection('auth_map').doc(user.uid).set({
        'nisn': nisn,
        'loginAt': FieldValue.serverTimestamp(),
      });

      // Simpan NISN di SharedPreferences (untuk query cepat)
      // atau gunakan langsung dari Firestore

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login berhasil!")));

        // PINDAH KE HALAMAN BERIKUTNYA
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DaftarKelasScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nisnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final w = size.maxWidth;
        final h = size.maxHeight;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              width: w,
              height: h,
              child: Stack(
                children: [
                  // GRADIENT ATAS
                  Container(
                    height: h * 0.45,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
                      ),
                    ),
                  ),
                  // LENGKUNG PUTIH
                  Positioned(
                    top: h * 0.27,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: h * 0.75,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(120),
                        ),
                      ),
                    ),
                  ),
                  // GRADIENT BAWAH
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: h * 0.11,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xFF1EAFFE), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  // KONTEN
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: h * 0.08),
                        Text(
                          "UJIAJA",
                          style: TextStyle(
                            fontFamily: "LeckerliOne",
                            fontSize: w * 0.13,
                            color: Colors.white,
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                          thickness: 2,
                          indent: w * 0.15,
                          endIndent: w * 0.15,
                        ),
                        SizedBox(height: h * 0.01),
                        Text(
                          "Silakan login menggunakan nama lengkap dan NIS.",
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: h * 0.15),
                        Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: w * 0.08,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF126998),
                          ),
                        ),
                        SizedBox(height: h * 0.03),
                        inputField("Nama", _namaController),
                        SizedBox(height: h * 0.025),
                        inputField("NISN", _nisnController),
                        SizedBox(height: h * 0.045),
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color(0xFF126998),
                              )
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF126998),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.23,
                                    vertical: h * 0.018,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF1EAFFE)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
          ),
        ),
      ),
    );
  }
}
