// lib/screen/guru/daftarNilai.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DaftarNilai extends StatefulWidget {
  final String kelas;
  final String jurusanId;

  const DaftarNilai({super.key, required this.kelas, required this.jurusanId});

  @override
  State<DaftarNilai> createState() => _DaftarNilaiState();
}

class _DaftarNilaiState extends State<DaftarNilai> {
  List<Map<String, dynamic>> hasil = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNilai();
  }

  Future<void> _loadNilai() async {
    try {
      final res = await Supabase.instance.client
          .from('hasil')
          .select('''
            nilai, benar, total_soal,
            siswa:siswa_nisn(nama, nisn)
          ''')
          .eq('kelas', widget.kelas)
          .order('nilai', ascending: false);

      if (mounted) {
        setState(() {
          hasil = List<Map<String, dynamic>>.from(res);
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  Color _warnaNilai(double n) {
    if (n >= 85) return Colors.green;
    if (n >= 70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: Text('Nilai ${widget.kelas}'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : hasil.isEmpty
          ? const Center(child: Text('Belum ada hasil ulangan'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hasil.length,
              itemBuilder: (context, i) {
                final h = hasil[i];
                final siswa = h['siswa'] as Map<String, dynamic>;
                final nilai = (h['nilai'] as num).toDouble();

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _warnaNilai(nilai).withOpacity(0.2),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: _warnaNilai(nilai),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(siswa['nama']),
                    subtitle: Text('NISN: ${siswa['nisn']}'),
                    trailing: Text(
                      nilai.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _warnaNilai(nilai),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
