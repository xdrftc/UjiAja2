import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class DaftarNilaiScreen extends StatefulWidget {
  const DaftarNilaiScreen({Key? key}) : super(key: key);

  @override
  State<DaftarNilaiScreen> createState() => _DaftarNilaiScreenState();
}

class _DaftarNilaiScreenState extends State<DaftarNilaiScreen> {
  late Future<List<Map<String, dynamic>>> _nilaiFuture;

  @override
  void initState() {
    super.initState();
    _nilaiFuture = _loadNilai();
  }

  Future<List<Map<String, dynamic>>> _loadNilai() async {
    final userNisn = supabase.auth.currentUser?.id;
    if (userNisn == null) return [];

    final hasil = await supabase
        .from('hasil')
        .select('nilai, ujian_nama')
        .eq('siswa_nisn', userNisn)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(hasil);
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
              // Tombol Back
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Judul
              const Text(
                "Daftar Nilai",
                style: TextStyle(
                  fontFamily: 'LeckerliOne',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Deskripsi
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Halaman ini menampilkan daftar nilai dari seluruh ujian yang telah Anda selesaikan. Silakan cek hasil Anda untuk melihat perkembangan belajar!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Daftar Nilai
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _nilaiFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error memuat nilai',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final nilaiList = snapshot.data!;
                    if (nilaiList.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada nilai',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      itemCount: nilaiList.length,
                      itemBuilder: (context, i) {
                        final item = nilaiList[i];
                        return _buildNilaiCard(
                          mapel: item['ujian_nama'],
                          nilai: item['nilai'],
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNilaiCard({required String mapel, required int nilai}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon Siswa
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),

          const SizedBox(width: 16),

          // Nama Mapel
          Expanded(
            child: Text(
              mapel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),

          // Nilai
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              nilai.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
