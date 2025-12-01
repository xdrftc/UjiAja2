// lib/screen/guru/loginGuru.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'homescreenGuru.dart';

class LoginGuru extends StatefulWidget {
  const LoginGuru({super.key});
  @override
  State<LoginGuru> createState() => _LoginGuruState();
}

class _LoginGuruState extends State<LoginGuru> {
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final _nipController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  String? message;

  Future<void> _loginOrRegister() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      message = null;
    });

    final nip = _nipController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (nip.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        message = 'Semua kolom harus diisi!';
        isLoading = false;
      });
      return;
    }

    try {
      // COBA LOGIN DULU
      final loginResponse = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      // KALAU BERHASIL LOGIN → LANGSUNG MASUK
      await _saveNipToGuruTable(loginResponse.user!.id, nip);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomescreenGuru()),
      );
    } catch (e) {
      // KALAU GAGAL LOGIN (biasanya email belum ada atau password salah)
      if (e.toString().contains('Invalid login credentials') ||
          e.toString().contains('User not found')) {
        try {
          // OTOMATIS DAFTAR BARU
          final signUpResponse = await Supabase.instance.client.auth.signUp(
            email: email,
            password: password,
          );

          // Simpan NIP ke tabel guru
          await _saveNipToGuruTable(signUpResponse.user!.id, nip);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun berhasil dibuat! Selamat datang 👋'),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomescreenGuru()),
          );
        } catch (signupError) {
          if (!mounted) return;
          setState(() {
            message = 'Gagal membuat akun: ${signupError.toString()}';
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          message = 'Error: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Fungsi bantu simpan NIP ke tabel guru
  Future<void> _saveNipToGuruTable(String userId, String nip) async {
    try {
      await Supabase.instance.client.from('guru').upsert({
        'id': userId,
        'nip': nip.trim(),
      });
      // TIDAK PAKAI onConflict → ini yang bikin crash!
    } catch (e) {
      print('Info: NIP belum tersimpan (bisa diabaikan): $e');
    }
  }

  @override
  void dispose() {
    _nipController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _messengerKey, // TAMBAH INI
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // === BAGIAN ATAS BIRU GRADIENT ===
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(32, 60, 32, 80),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'UJIAJA',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 3, width: 100, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      '"Silakan login menggunakan nama lengkap dan NIS."',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    _buildTextField(_nipController, 'NIP'),
                    const SizedBox(height: 20),
                    _buildTextField(
                      _emailController,
                      'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      _passwordController,
                      'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),

                    if (message != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          message!,
                          style: TextStyle(
                            color: message!.contains('berhasil')
                                ? Colors.green
                                : Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _loginOrRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
  }

  Widget _buildTextField(
    TextEditingController c,
    String label, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: c,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF0D47A1)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 3),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
    );
  }
}
