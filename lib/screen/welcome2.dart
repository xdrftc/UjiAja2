import 'package:flutter/material.dart';
import 'package:ujiaja/screen/siswa/loginsiswa.dart';

class HomeUjiAjaPage extends StatelessWidget {
  const HomeUjiAjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E8BFF), Color(0xFF1565D8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const SizedBox(height: 25),

              // ===== LOGO TULISAN UJiAja =====
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 80), // jarak atas
                    const Text(
                      "UJiAja",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        fontFamily: "LeckerliOne",
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(width: 200, height: 2, color: Colors.white70),

                    const SizedBox(height: 5),

                    const Text(
                      "Selamat datang di UjiAja!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),

                    const SizedBox(height: 40), // jarak ke gambar bawah
                  ],
                ),
              ),

              // ===== GAMBAR SISWA =====
              Flexible(
                flex: 2, // memberi proporsi lebih besar dibanding elemen lain
                child: Center(
                  child: Image.asset(
                    "assets/images/images5.png",
                    width:
                        MediaQuery.of(context).size.width *
                        0.9, // 90% lebar layar
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ===== BUTTON SISWA =====
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginSiswa(),
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

              const SizedBox(height: 15),

              // ===== BUTTON GURU =====
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
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

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
