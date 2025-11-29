// lib/screen/siswa/hasil_ujian_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class HasilUjianScreen extends StatefulWidget {
  final int nilai;
  final int benar;
  final int total;

  const HasilUjianScreen({
    Key? key,
    required this.nilai,
    required this.benar,
    required this.total,
  }) : super(key: key);

  @override
  State<HasilUjianScreen> createState() => _HasilUjianScreenState();
}

class _HasilUjianScreenState extends State<HasilUjianScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Glow Animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Auto close setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Judul
              const Text(
                "Hasil Ujian",
                style: TextStyle(
                  fontFamily: 'LeckerliOne',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 60),

              // Kartu Hasil (dengan glow)
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.4),
                          blurRadius: _glowAnimation.value,
                          spreadRadius: _glowAnimation.value / 2,
                        ),
                        const BoxShadow(color: Colors.white, blurRadius: 16),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Animasi Check
                        Lottie.asset(
                          'assets/anim/check.json',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 20),

                        // Teks Terkirim
                        const Text(
                          "UJIAN ANDA TELAH\nTERKIRIM!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        // Nilai Anda
                        const Text(
                          "Nilai anda:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF0D47A1),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Nilai Besar
                        Text(
                          widget.nilai.toString(),
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Benar / Total
                        Text(
                          "BENAR ${widget.benar}/${widget.total}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(),

              // Tombol Simpan
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 40,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D47A1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.cyan,
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
