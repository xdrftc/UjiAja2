import 'package:flutter/material.dart';

class PanduanScreen extends StatelessWidget {
  const PanduanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E40AF), // biru solid sesuai desain
      body: SafeArea(
        child: Column(
          children: [
            // === BACK BUTTON ===
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === JUDUL "Panduan" ===
            const Text(
              'Panduan',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins', // ganti jika pakai font lain
              ),
            ),

            const SizedBox(height: 40),

            // === TEKS PANDUAN ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Sebelum mulai, pastikan koneksi stabil dan baca instruksi dengan baik. Kerjakan soal dengan jujur sesuai waktu yang tersedia.\n\n',
                    ),
                    TextSpan(
                      text:
                          'Periksa kembali jawaban Anda, lalu tekan "Selesai Ujian" untuk mengirim hasil.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),

            // === ILUSTRASI SISWA ===
            Expanded(
              child: Image.asset(
                'assets/images/panduan_illustration.png', // GANTI DENGAN GAMBAR ANDA
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika gambar belum ada
                  return const Center(
                    child: Icon(Icons.school, size: 180, color: Colors.white70),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
