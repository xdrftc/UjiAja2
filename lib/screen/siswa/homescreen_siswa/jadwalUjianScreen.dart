import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screenUjian.dart'; // ← halaman ujian

class JadwalUjianScreen extends StatelessWidget {
  final String kelas;
  const JadwalUjianScreen({Key? key, required this.kelas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Ujian Hari Ini')),
      body: StreamBuilder(
        stream: supabase
            .from('jadwal_ujian')
            .stream(primaryKey: ['id'])
            .eq('kelas', kelas)
            .eq('tanggal', todayStr)
            .order('jam_mulai'),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final jadwal = snapshot.data!;

          if (jadwal.isEmpty) {
            return const Center(child: Text('Tidak ada ujian hari ini'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jadwal.length,
            itemBuilder: (context, i) {
              final item = jadwal[i];
              final jamMulai = item['jam_mulai'].substring(0, 5);
              final jamSelesai = item['jam_selesai'].substring(0, 5);

              return Card(
                child: ListTile(
                  title: FutureBuilder(
                    future: supabase
                        .from('mata_pelajaran')
                        .select('nama')
                        .eq('id', item['mapel_id'])
                        .single(),
                    builder: (context, snap) {
                      return Text(snap.data?['nama'] ?? 'Loading...');
                    },
                  ),
                  subtitle: Text('$jamMulai - $jamSelesai'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UjianScreen(ujianId: item['id']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
