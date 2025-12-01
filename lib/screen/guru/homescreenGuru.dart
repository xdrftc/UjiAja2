import 'package:flutter/material.dart';

class HomescreenGuru extends StatelessWidget {
  const HomescreenGuru({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
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

          // Judul UJHAJA
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
                const SizedBox(height: 6), // jarak antara teks & garis
                Container(
                  width: 180, // panjang garis
                  height: 4, // ketebalan garis
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

          // Gambar siswa (now right side)
          Positioned(
            bottom: 0,
            right: 150,
            child: SizedBox(
              height: h * 0.56,
              child: Image.asset("assets/images/5.png", fit: BoxFit.contain),
            ),
          ),

          // Menu item container lebih ke bawah dan berjarak
          Positioned(
            top: h * 0.45,
            right: w * 0.08,
            child: Column(
              children: [
                _menuItem(icon: Icons.person, text: "Pengguna", onTap: () {}),
                const SizedBox(height: 18), // jarak
                _menuItem(
                  icon: Icons.list_alt,
                  text: "Soal Ulangan",
                  onTap: () {},
                ),
                const SizedBox(height: 18), // jarak
                _menuItem(
                  icon: Icons.grade,
                  text: "Nilai Ulangan",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String text,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Color(0xFF126998)),
            const SizedBox(height: 6),
            Text(
              text,
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
