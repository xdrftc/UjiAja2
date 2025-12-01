import 'package:flutter/material.dart';

class DaftarSoalScreen extends StatelessWidget {
  const DaftarSoalScreen({Key? key}) : super(key: key);

  // Daftar kelas beserta warna & path ikon (ganti dengan asset Anda nanti)
  final List<Map<String, dynamic>> kelasList = const [
    {'nama': 'TEI', 'color': Colors.red, 'icon': 'assets/icons/tei.png'},
    {'nama': 'TITL', 'color': Colors.orange, 'icon': 'assets/icons/titl.png'},
    {'nama': 'TPM', 'color': Colors.cyan, 'icon': 'assets/icons/tpm.png'},
    {'nama': 'TPL', 'color': Colors.blue, 'icon': 'assets/icons/tpl.png'},
    {'nama': 'TKRO', 'color': Colors.indigo, 'icon': 'assets/icons/tkro.png'},
    {'nama': 'TKJ', 'color': Colors.green, 'icon': 'assets/icons/tkj.png'},
    {'nama': 'RPL', 'color': Colors.teal, 'icon': 'assets/icons/rpl.png'},
    {'nama': 'DPB', 'color': Colors.yellow, 'icon': 'assets/icons/dpib.png'},
    {'nama': 'SK', 'color': Colors.purple, 'icon': 'assets/icons/sk.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ILUSTRASI ===
            Stack(
              children: [
                // Background biru gradient + ilustrasi
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1E3A8A), Color(0xFF172554)],
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/images2.png', // ganti dengan ilustrasi Anda
                    fit: BoxFit.cover,
                  ),
                ),
                // Tombol back
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Judul
                const Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Daftar kelas',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins', // atau font yang Anda pakai
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: Divider(color: Colors.white70, thickness: 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // === GRID KELAS ===
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemCount: kelasList.length,
                  itemBuilder: (context, index) {
                    final kelas = kelasList[index];
                    return GestureDetector(
                      onTap: () {
                        // TODO: Navigasi ke halaman detail kelas
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Masuk ke kelas ${kelas['nama']}'),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Ikon kelas (segitiga + logo)
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kelas['color'],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(
                                  kelas['icon'],
                                  width: 45,
                                  height: 45,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Jika asset belum ada, fallback ke icon default
                                    return Icon(
                                      Icons.school,
                                      color: Colors.white,
                                      size: 40,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              kelas['nama'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
