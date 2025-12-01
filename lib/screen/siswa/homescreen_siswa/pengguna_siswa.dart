// lib/screen/siswa/pengguna/pengguna_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class PenggunaSiswaPage extends StatefulWidget {
  const PenggunaSiswaPage({super.key, required Map<String, dynamic> siswa});
  @override
  State<PenggunaSiswaPage> createState() => _PenggunaSiswaPageState();
}

class _PenggunaSiswaPageState extends State<PenggunaSiswaPage> {
  Map<String, dynamic>? _siswa;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        Navigator.pop(context);
        return;
      }

      final nisn = user.email?.split('@').first ?? '';
      final res = await supabase
          .from('siswa')
          .select()
          .eq('nisn', nisn)
          .single();

      setState(() {
        _siswa = res;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat profil: $e")));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1EAFFE),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              children: [
                // BACKGROUND BIRU
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
                    ),
                  ),
                ),

                // KARTU PROFIL
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: size.height * 0.7,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          // FOTO PROFIL
                          Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFF126998),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // JUDUL
                          const Text(
                            "Pengguna",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF126998),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // DATA
                          _buildInfoField("Nama", _siswa?['nama'] ?? '-'),
                          const SizedBox(height: 16),
                          _buildInfoField("Nisn", _siswa?['nisn'] ?? '-'),
                          const SizedBox(height: 16),
                          _buildInfoField("Kelas", _siswa?['kelas'] ?? '-'),
                          const SizedBox(height: 16),
                          _buildInfoField("Jurusan", _siswa?['jurusan'] ?? '-'),
                          const SizedBox(height: 16),
                          _buildInfoField("Email", _siswa?['email'] ?? '-'),
                          const SizedBox(height: 40),

                          // TOMBOL KEMBALI
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF126998),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Kembali",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1EAFFE), width: 1.5),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1EAFFE),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
