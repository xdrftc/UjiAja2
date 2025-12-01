// lib/screen/guru/daftar_nilai_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DaftarNilaiScreen extends ConsumerStatefulWidget {
  final String kelas;
  final String jurusanId;

  const DaftarNilaiScreen({
    super.key,
    required this.kelas,
    required this.jurusanId,
  });

  @override
  ConsumerState<DaftarNilaiScreen> createState() => _DaftarNilaiScreenState();
}

class _DaftarNilaiScreenState extends ConsumerState<DaftarNilaiScreen> {
  List<Map<String, dynamic>> hasilUlangan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNilai();
  }

  Future<void> _loadNilai() async {
    try {
      final response = await Supabase.instance.client
          .from('hasil')
          .select('''
            id,
            nilai,
            benar,
            total_soal,
            tanggal,
            siswa:siswa_nisn (nama, nisn)
          ''')
          .eq('kelas', widget.kelas)
          .order('nilai', ascending: false);

      setState(() {
        hasilUlangan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat nilai siswa')),
        );
      }
    }
  }

  // Fungsi untuk warna berdasarkan nilai
  Color _getNilaiColor(double nilai) {
    if (nilai >= 85) return Colors.green;
    if (nilai >= 70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hasil Ulangan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Header biru (Frame 19)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF172554)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.kelas,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daftar nilai seluruh siswa',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Info jumlah siswa & rata-rata
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard('Jumlah Siswa', '${hasilUlangan.length}'),
                _infoCard('Rata-rata Kelas', '82.5'),
              ],
            ),
          ),

          // List nilai siswa
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                  )
                : hasilUlangan.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_late_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada hasil ulangan',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: hasilUlangan.length,
                    itemBuilder: (context, index) {
                      final h = hasilUlangan[index];
                      final siswa = h['siswa'] as Map<String, dynamic>;
                      final nilai = (h['nilai'] as num).toDouble();
                      final color = _getNilaiColor(nilai);

                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: color.withOpacity(0.2),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                          title: Text(
                            siswa['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Text('NISN: ${siswa['nisn']}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                nilai.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: color, // SUDAH DIPERBAIKI DI SINI
                                ),
                              ),
                              Text(
                                '${h['benar']}/${h['total_soal']} benar',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Detail ${siswa['nama']}'),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
