import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'jadwal_ujian_screen.dart'; // ← halaman baru

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? siswaKelas;
  String? siswaNama;

  @override
  void initState() {
    super.initState();
    _loadSiswaData();
  }

  Future<void> _loadSiswaData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('siswa')
        .select('nama, kelas')
        .eq('nisn', user.id)
        .single();

    setState(() {
      siswaNama = data['nama'];
      siswaKelas = data['kelas'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final double scale = width / 390;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1FA2FF), Color(0xFF003A5B)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20 * scale,
              vertical: 25 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30 * scale),

                // Judul UjiAja
                Text(
                  "UjiAja",
                  style: TextStyle(
                    fontFamily: 'LeckerliOne',
                    fontSize: 60 * scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 6 * scale, bottom: 10 * scale),
                  height: 1.5,
                  width: 160 * scale,
                  color: Colors.white54,
                ),

                // Selamat datang + nama siswa
                Text(
                  siswaNama != null
                      ? "Halo $siswaNama,\nsemoga belajarmu menyenangkan!"
                      : "Halo Teman,\nsemoga belajarmu menyenangkan!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14 * scale,
                    height: 1.9,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 100 * scale),

                // Tombol Menu
                Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      MenuCard(
                        scale: scale,
                        icon: Icons.menu_book,
                        label: "Jadwal Ujian Hari Ini",
                        onTap: () {
                          if (siswaKelas != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    JadwalUjianScreen(kelas: siswaKelas!),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 15 * scale),
                      MenuCard(
                        scale: scale,
                        icon: Icons.history,
                        label: "Riwayat Nilai",
                        onTap: () {
                          // TODO: ke RiwayatScreen
                        },
                      ),
                      SizedBox(height: 15 * scale),
                      MenuCard(
                        scale: scale,
                        icon: Icons.error_outline,
                        label: "Panduan",
                        onTap: () {
                          // TODO: ke PanduanScreen
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// MenuCard tetap sama
class MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double scale;

  const MenuCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15 * scale),
      child: InkWell(
        borderRadius: BorderRadius.circular(15 * scale),
        onTap: onTap,
        child: Container(
          height: 60 * scale,
          padding: EdgeInsets.symmetric(horizontal: 10 * scale),
          child: Row(
            children: [
              Container(
                width: 50 * scale,
                height: 50 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
                child: Icon(icon, color: Colors.white, size: 28 * scale),
              ),
              SizedBox(width: 20 * scale),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20 * scale,
                  color: const Color(0xFF0D47A1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
