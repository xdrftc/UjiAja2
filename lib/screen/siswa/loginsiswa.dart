import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

import 'package:ujiaja/screen/siswa/homescreen_siswa/homescreenSiswa.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  bool _isLoading = false;

  String _generatePassword() {
    return (10000000 + Random().nextInt(90000000)).toString();
  }

  Future<void> _login() async {
    final nama = _namaController.text.trim();
    final nisn = _nisnController.text.trim();

    if (nama.isEmpty || nisn.isEmpty) {
      _showSnackBar("Nama dan NISN harus diisi");
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(nisn)) {
      _showSnackBar("NISN harus 10 digit angka");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = '$nisn@ujiaja.local';

      // 1. Cek apakah siswa sudah ada
      final siswaResponse = await supabase
          .from('siswa')
          .select()
          .eq('nisn', nisn)
          .maybeSingle();

      if (siswaResponse != null) {
        final data = siswaResponse as Map;
        if (data['nama'].toString().toLowerCase() != nama.toLowerCase()) {
          _showSnackBar("Nama tidak sesuai dengan NISN");
          return;
        }
      }

      // 2. Login / Register via Supabase Auth
      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: email, // password = email (sementara)
      );

      if (authResponse.user == null) {
        // Jika belum ada, register dulu
        final password = _generatePassword();
        await supabase.auth.signUp(email: email, password: password);

        // Simpan data siswa
        await supabase.from('siswa').insert({
          'nisn': nisn,
          'nama': nama,
          'role': 'siswa',
        });
      } else if (siswaResponse == null) {
        // Jika auth ada tapi data siswa belum → buat
        await supabase.from('siswa').insert({
          'nisn': nisn,
          'nama': nama,
          'role': 'siswa',
        });
      }

      if (mounted) {
        _showSnackBar("Login berhasil!");
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
                        inputField(
                          "NISN",
                          _nisnController,
                          keyboardType: TextInputType.number,
                        ),
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

  Widget inputField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
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
