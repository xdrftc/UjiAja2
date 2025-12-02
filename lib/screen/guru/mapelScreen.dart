import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/guru/buatUlangan.dart';

class PilihMapelScreen extends StatefulWidget {
  const PilihMapelScreen({super.key});

  @override
  State<PilihMapelScreen> createState() => _PilihMapelScreenState();
}

class _PilihMapelScreenState extends State<PilihMapelScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> mapelList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMapel();
  }

  Future<void> _loadMapel() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        Navigator.pushReplacementNamed(context, '/login_guru');
        return;
      }

      // Ambil semua mata pelajaran yang diajar oleh guru ini
      final response = await supabase
          .from('mata_pelajaran')
          .select('id, kode, nama')
          .order('nama');

      setState(() {
        mapelList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat mata pelajaran: $e")),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Judul Mapel
              const Text(
                "Mapel",
                style: TextStyle(
                  fontFamily: "LeckerliOne",
                  fontSize: 56,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),

              // Deskripsi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Halaman ini menampilkan daftar mata pelajaran yang Anda ajar. Pilih salah satu untuk melihat atau membuat soal ulangan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Grid Mapel
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                          itemCount: mapelList.length,
                          itemBuilder: (context, index) {
                            final mapel = mapelList[index];
                            final kode =
                                mapel['kode']?.toString().toUpperCase() ??
                                '???';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BuatSoalScreen(
                                      mapelId: mapel['id'].toString(),
                                      namaMapel: mapel['nama'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Logo lingkaran dengan kode mapel
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundColor: const Color(0xFF126998),
                                      child: Text(
                                        kode,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Nama mapel
                                    Text(
                                      mapel['nama'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
