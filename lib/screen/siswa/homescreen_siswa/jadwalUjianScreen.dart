import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Jadwal Ujian Hari Ini'),
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('jadwal_ujian')
            .select()
            .eq('kelas', kelas)
            .eq('tanggal', todayStr)
            .order('jam_mulai')
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

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
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: FutureBuilder<Map<String, dynamic>?>(
                    future: supabase
                        .from('mata_pelajaran')
                        .select('nama')
                        .eq('id', item['mapel_id'])
                        .single(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Text(
                          snap.data!['nama'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }
                      return const Text('Loading...');
                    },
                  ),
                  subtitle: Text(
                    '$jamMulai - $jamSelesai',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UjianScreen(ujianId: item['ujian_id']),
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
