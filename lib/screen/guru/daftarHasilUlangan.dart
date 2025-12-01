// lib/screen/guru/daftarHasilUlangan.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detailjurusan.dart';

class DaftarHasilUlangan extends StatefulWidget {
  const DaftarHasilUlangan({super.key});
  @override
  State<DaftarHasilUlangan> createState() => _DaftarHasilUlanganState();
}

class _DaftarHasilUlanganState extends State<DaftarHasilUlangan> {
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

      if (mounted) {
        setState(() {
          jurusan = list;
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
        title: const Text('Hasil Ulangan'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : jurusan.isEmpty
          ? const Center(child: Text('Belum ada jurusan yang diampu'))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: jurusan.length,
              itemBuilder: (context, i) {
                final j = jurusan[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailJurusan(
                          jurusanId: j['id'],
                          mode: 'hasil', // KINI SUDAH DIKASIH!
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(j['logo'], width: 80, height: 80),
                        const SizedBox(height: 12),
                        Text(
                          j['nama'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
