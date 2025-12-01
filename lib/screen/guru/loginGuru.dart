// lib/screen/guru/loginGuru.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../provider/authProvider.dart';

class LoginGuru extends ConsumerStatefulWidget {
  const LoginGuru({super.key});

  @override
  ConsumerState<LoginGuru> createState() => _LoginGuruState();
}

class _LoginGuruState extends ConsumerState<LoginGuru> {
  final _nipController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _nipController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .signIn(
            nip: _nipController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // INI PALING PENTING: CEK mounted SEBELUM PINDAH HALAMAN
      if (!mounted) return;

      context.go('/homescreenGuru');
    } catch (e) {
      // INI JUGA HARUS DICEK
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      // HANYA JALANKAN KALAU MASIH MOUNTED
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau judul
              const Text(
                'Login Guru',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),

              const SizedBox(height: 20),

              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Masuk', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
