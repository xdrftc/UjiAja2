import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ujiaja/provider/authProvider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _namaController = TextEditingController();
  final _nipController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider.select((s) => s.currentUser));
    return Scaffold(
      appBar: AppBar(title: Text('Pengguna')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _nipController,
              decoration: InputDecoration(labelText: 'NIP'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Kembali'),
            ), // Sesuai screenshot "Kembali" mungkin typo, asumsikan "Simpan"
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    // Update via Supabase
    await ref
        .read(supabaseProvider)
        .from('profiles')
        .update({
          'nama': _namaController.text,
          'nip': _nipController.text, // Update di guru table
        })
        .eq('id', ref.read(authProvider).currentUser!.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profil updated!')));
  }
}
