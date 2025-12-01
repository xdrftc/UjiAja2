import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ujiaja/provider/authProvider.dart';

class BuatSoalScreen extends ConsumerStatefulWidget {
  const BuatSoalScreen({super.key});

  @override
  ConsumerState<BuatSoalScreen> createState() => _BuatSoalScreenState();
}

class _BuatSoalScreenState extends ConsumerState<BuatSoalScreen> {
  final _pertanyaanController = TextEditingController();

  Future<void> _simpanSoal() async {
    final userId = ref.read(authProvider).currentUser?.id;
    // atau: ref.read(authProvider).user?.id

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harus login dulu!')));
      return;
    }

    try {
      await ref.read(supabaseProvider).from('soal').insert({
        'pertanyaan': _pertanyaanController.text,
        'pilihan': {
          'A': 'Pilihan A',
          'B': 'Pilihan B',
          'C': 'Pilihan C',
          'D': 'Pilihan D',
        },
        'jawaban_benar': 'A',
        'ujian_id': 'temp-ujian-id', // nanti diganti sesuai ujian
        'guru_id': userId, // ← INI YANG KAMU CARI!
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
