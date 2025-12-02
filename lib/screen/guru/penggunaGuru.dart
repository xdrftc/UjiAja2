import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileGuru extends StatefulWidget {
  const ProfileGuru({super.key});

  @override
  State<ProfileGuru> createState() => _ProfileGuruScreenState();
}

class _ProfileGuruScreenState extends State<ProfileGuru> {
  final _namaController = TextEditingController();
  final _nipController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('nama, email')
          .eq('id', userId)
          .single();

      final guruRes = await Supabase.instance.client
          .from('guru')
          .select('nip')
          .eq('id', userId)
          .single();

      setState(() {
        _namaController.text = res['nama'] ?? '';
        _emailController.text = res['email'] ?? '';
        _nipController.text = guruRes['nip'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
    }
  }

  Future<void> _updateProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'nama': _namaController.text})
          .eq('id', userId);

      await Supabase.instance.client
          .from('guru')
          .update({'nip': _nipController.text})
          .eq('id', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui profil: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _nipController,
              decoration: const InputDecoration(labelText: 'NIP'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false, // Email tidak dapat diubah
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
