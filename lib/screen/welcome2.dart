// lib/screen/welcome/welcome2.dart
import 'package:flutter/material.dart';
import 'package:ujiaja/screen/siswa/loginsiswa.dart';

class HomeUjiAjaPage extends StatelessWidget {
  const HomeUjiAjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double buttonHeight = 55;
    final double spacing = 10;
    final double bottomPadding = 40;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E8BFF), Color(0xFF1565D8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // ===== LOGO UJiAja =====
                        const Text(
                          "UJiAja",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontWeight: FontWeight.w900,
                            fontFamily: "LeckerliOne",
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(width: 180, height: 2, color: Colors.white70),
                        const SizedBox(height: 6),
                        const Text(
                          "Selamat datang di UjiAja!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 20),

                        // ===== GAMBAR SISWA (RESPONSIF) =====
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              "assets/images/images5.png",
                              fit: BoxFit.contain,
                              width: size.width * 0.85,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ===== BUTTON SISWA =====
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginSiswa(),
                                ),
                              );
                            },
                            child: const Text(
                              "SISWA",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: spacing),

                        // ===== BUTTON GURU =====
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // TODO: Navigasi ke halaman guru
                            },
                            child: const Text(
                              "GURU",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: bottomPadding),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
