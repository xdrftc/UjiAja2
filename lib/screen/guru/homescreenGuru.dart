import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Ganti import-import screen yang akan kamu tuju di sini
import 'package:ujiaja/screen/guru/penggunaGuru.dart';
import 'package:ujiaja/screen/guru/daftarSoalUlangan.dart';
import 'package:ujiaja/screen/guru/daftarHasilUlangan.dart';
import 'package:ujiaja/screen/guru/daftarNilai.dart';

class HomescreenGuru extends StatelessWidget {
  const HomescreenGuru({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Fungsi logout biar rapi
    Future<void> _logout() async {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login_guru', // pastikan route ini sudah ada di MaterialApp
          (route) => false,
        );
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true, // biar gradient sampai atas
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 28),
            onPressed: _logout,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: w,
            height: h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
              ),
            ),
          ),

          // Judul UJIAJA
          Positioned(
            top: h * 0.10,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "UjiAja",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 80,
                    fontFamily: "LeckerliOne",
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 180,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Teks sambutan
          Positioned(
            top: h * 0.20,
            left: 40,
            right: 40,
            child: const Text(
              "Halo Teman, selamat datang di aplikasi UjiAja!\n"
              "Semoga hari ini kamu siap mengikuti ujianmu dan\n"
              "terus meningkatkan kemampuan belajarmu.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.white),
            ),
          ),

          // Gambar siswa
          Positioned(
            bottom: 0,
            right: 150,
            child: SizedBox(
              height: h * 0.56,
              child: Image.asset(
                "assets/images/images5.png",
                fit: BoxFit.contain,
              ),
            ),
          ),

          // MENU (hanya ganti onTap-nya)
          Positioned(
            top: h * 0.45,
            right: w * 0.08,
            child: Column(
              children: [
                _menuItem(
                  icon: Icons.person,
                  text: "Pengguna",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileGuru()),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _menuItem(
                  icon: Icons.list_alt,
                  text: "Soal Ulangan",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DaftarSoalUlangan(mapel: ''),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _menuItem(
                  icon: Icons.grade,
                  text: "Nilai Ulangan",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DaftarNilai(kelas: '', jurusanId: ''),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget menu (tetap persis sama, cuma onTap yang dipakai)
  Widget _menuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF126998)),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
