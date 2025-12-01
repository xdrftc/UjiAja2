// lib/screens/pilih_kelas_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PilihKelasScreen extends ConsumerStatefulWidget {
  final String jurusanId;
  final String mode;
  const PilihKelasScreen({
    super.key,
    required this.jurusanId,
    required this.mode,
  });

  @override
  ConsumerState<PilihKelasScreen> createState() => _PilihKelasScreenState();
}

class _PilihKelasScreenState extends ConsumerState<PilihKelasScreen> {
  List<Map<String, dynamic>> kelas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Supabase.instance.client
        .from('kelas')
        .select('id, nama')
        .eq('jurusan_id', widget.jurusanId)
        .order('nama')
        .then((data) {
          setState(() {
            kelas = List<Map<String, dynamic>>.from(data);
            loading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == 'soal'
              ? 'Pilih Kelas untuk Soal'
              : 'Pilih Kelas untuk Hasil',
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: kelas.length,
              itemBuilder: (_, i) {
                final k = kelas[i];
                return ListTile(
                  leading: const Icon(Icons.class_, color: Colors.blue),
                  title: Text(
                    k['nama'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (widget.mode == 'soal') {
                      context.go(
                        '/buat-soal?kelas=${k['nama']}&jurusanId=${widget.jurusanId}',
                      );
                    } else {
                      context.go(
                        '/daftar-nilai?kelas=${k['nama']}&jurusanId=${widget.jurusanId}',
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
