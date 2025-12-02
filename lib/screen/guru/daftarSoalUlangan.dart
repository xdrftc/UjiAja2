import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detailjurusan.dart';

class DaftarSoalUlangan extends StatefulWidget {
  final String mapel;

  const DaftarSoalUlangan({super.key, required this.mapel});

  @override
  State<DaftarSoalUlangan> createState() => _DaftarSoalUlanganState();
}

class _DaftarSoalUlanganState extends State<DaftarSoalUlangan> {
  List<Map<String, dynamic>> jurusan = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadJurusan();
  }

  Future<void> _loadJurusan() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) setState(() => loading = false);
      return;
    }

    try {
      final res = await Supabase.instance.client
          .from('guru_jurusan')
          .select('jurusan:jurusan_id(id,nama,warna)')
          .eq('guru_id', userId);

      final list = res.map((e) {
        final j = e['jurusan'] as Map<String, dynamic>;
        final namaFile = (j['nama'] as String).toLowerCase().replaceAll(
          ' ',
          '',
        );
        return {
          'id': j['id'],
          'nama': j['nama'],
          'warna': j['warna'] ?? '#1E3A8A',
          'logo': 'assets/images/jurusan/$namaFile.png',
        };
      }).toList();

      if (mounted) setState(() => jurusan = list);
    } catch (e) {
      // ignore
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pilih Jurusan - ${widget.mapel}')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
              ),
              itemCount: jurusan.length,
              itemBuilder: (context, index) {
                final j = jurusan[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailJurusan(jurusanId: j['id'], mode: 'soal'),
                      ),
                    );
                  },
                  child: Card(
                    color: Color(
                      int.parse(j['warna'].replaceFirst('#', '0xFF')),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(j['logo'], height: 50),
                        const SizedBox(height: 8),
                        Text(
                          j['nama'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
