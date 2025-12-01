// lib/screen/guru/detailjurusan.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'daftarNilai.dart';

class DetailJurusan extends StatefulWidget {
  final String jurusanId;
  final String mode; // sekarang BOLEH DIISI atau default 'hasil'

  const DetailJurusan({
    super.key,
    required this.jurusanId,
    this.mode = 'hasil', // DEFAULT → tidak wajib diisi lagi
  });

  @override
  State<DetailJurusan> createState() => _DetailJurusanState();
}

class _DetailJurusanState extends State<DetailJurusan> {
  List<Map<String, dynamic>> kelasList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  Future<void> _loadKelas() async {
    try {
      final res = await Supabase.instance.client
          .from('kelas')
          .select('id, nama')
          .eq('jurusan_id', widget.jurusanId)
          .order('nama');

      if (mounted) {
        setState(() {
          kelasList = List<Map<String, dynamic>>.from(res);
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: const Text('Pilih Kelas'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : kelasList.isEmpty
          ? const Center(child: Text('Belum ada kelas'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: kelasList.length,
              itemBuilder: (context, i) {
                final kelas = kelasList[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1E3A8A),
                      child: Text(
                        kelas['nama'][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      kelas['nama'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DaftarNilai(
                            kelas: kelas['nama'],
                            jurusanId: widget.jurusanId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
