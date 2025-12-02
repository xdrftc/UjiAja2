import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuatSoalScreen extends StatefulWidget {
  final String mapelId;
  final String namaMapel;

  const BuatSoalScreen({
    Key? key,
    required this.mapelId,
    required this.namaMapel,
  }) : super(key: key);

  @override
  State<BuatSoalScreen> createState() => _BuatSoalScreenState();
}

class _BuatSoalScreenState extends State<BuatSoalScreen> {
  final _pertanyaanController = TextEditingController();

  Future<void> _simpanSoal() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harus login dulu!')));
      return;
    }

    try {
      await Supabase.instance.client.from('soal').insert({
        'pertanyaan': _pertanyaanController.text,
        'pilihan': {
          'A': 'Pilihan A',
          'B': 'Pilihan B',
          'C': 'Pilihan C',
          'D': 'Pilihan D',
        },
        'jawaban_benar': 'A',
        'ujian_id': 'temp-ujian-id', // nanti diganti sesuai ujian
        'guru_id': userId, // ID guru yang sedang login
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Soal berhasil disimpan!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Soal Ulangan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pertanyaanController,
              decoration: const InputDecoration(labelText: 'Pertanyaan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simpanSoal,
              child: const Text('Simpan Soal'),
            ),
          ],
        ),
      ),
    );
  }
}
