import 'package:flutter/material.dart';

class PenggunaPageFix extends StatelessWidget {
  const PenggunaPageFix({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Full
          Container(
            width: w,
            height: h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Card putih melengkung
          Positioned(
            top: h * 0.26,
            child: Container(
              width: w,
              height: h * 0.74,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  topRight: Radius.circular(120),
                ),
              ),
            ),
          ),

          // Avatar
          Positioned(
            top: h * 0.17,
            left: (w / 2) - 85,
            child: CircleAvatar(
              radius: 85,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 68,
                backgroundColor: Color(0xFF1E3052),
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
          ),

          // Teks Pengguna tepat di bawah avatar
          Positioned(
            top: h * 0.33,
            left: 0,
            right: 0,
            child: const Text(
              "Pengguna",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),

          // Konten Form
          Positioned(
            top: h * 0.40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _inputOval("Nama"),
                const SizedBox(height: 20),
                _inputOval("Nip"),
                const SizedBox(height: 50),

                // Tombol Kembali
                Container(
                  width: w * 0.35,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xFF126998),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Kembali",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
    );
  }

  Widget _inputOval(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
          ),
        ),
      ),
    );
  }
}
