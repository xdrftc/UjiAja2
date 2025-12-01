// lib/screen/siswa/homescreen_siswa/homepage.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/siswa/loginsiswa.dart';
import 'pengguna_siswa.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _siswa;
  List<Map<String, dynamic>> _ujianList = [];
  List<Map<String, dynamic>> _nilaiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // TAMBAHKAN FUNGSI INI!
  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        _logout();
        return;
      }

      // GUNAKAN EMAIL DARI AUTH → CARI SISWA
      final siswaRes = await supabase
          .from('siswa')
          .select()
          .eq('email', user.email!)
          .maybeSingle(); // AMAN JIKA TIDAK ADA

      if (siswaRes == null) {
        _showSnackBar("Data siswa tidak ditemukan");
        _logout();
        return;
      }

      // ignore: unnecessary_cast
      final siswa = siswaRes as Map<String, dynamic>;
      final nisn = siswa['nisn'];

      final ujianRes = await supabase
          .from('ujian')
          .select('id, nama, mapel_id, durasi, mata_pelajaran!mapel_id(nama)')
          .eq('kelas', siswa['kelas']);

      final nilaiRes = await supabase
          .from('hasil')
          .select(
            'ujian_id, nilai, benar, total_soal, created_at, ujian!ujian_id(nama)',
          )
          .eq('siswa_nisn', nisn)
          .order('created_at', ascending: false);

      setState(() {
        _siswa = siswa;
        _ujianList = List.from(ujianRes);
        _nilaiList = List.from(nilaiRes);
        _isLoading = false;
      });
    } catch (e) {
      _showSnackBar("Error: $e"); // SEKARANG ADA!
      setState(() => _isLoading = false);
    }
  }

  void _logout() {
    supabase.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginSiswa()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF126998),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "UJIAJA",
          style: TextStyle(
            fontFamily: "LeckerliOne",
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // SELAMAT DATANG
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Halo Teman, semoga aktivitas belajarmu menyenangkan!",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        if (_siswa != null)
                          Text(
                            "${_siswa!['nama']} • ${_siswa!['kelas']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // MENU
                  _menuCard(
                    Icons.person_search,
                    "Pengguna",
                    "Lihat profil & data diri",
                    _showProfil,
                  ),
                  const SizedBox(height: 16),
                  _menuCard(
                    Icons.quiz,
                    "Soal Ulangan",
                    "${_ujianList.length} ujian tersedia",
                    _showUjian,
                  ),
                  const SizedBox(height: 16),
                  _menuCard(
                    Icons.bar_chart,
                    "Nilai",
                    "${_nilaiList.length} riwayat nilai",
                    _showNilai,
                  ),
                  const SizedBox(height: 16),
                  _menuCard(
                    Icons.help,
                    "Panduan",
                    "Cara pakai UjiAja",
                    _showPanduan,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _menuCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF126998),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF126998),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF126998)),
          ],
        ),
      ),
    );
  }

  void _showProfil() {
    if (_siswa == null) {
      _showSnackBar("Data profil tidak tersedia");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PenggunaSiswaPage(siswa: _siswa!), // PASS DATA!
      ),
    );
  }

  void _showUjian() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(24),
          child: _ujianList.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada ujian",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  controller: controller,
                  itemCount: _ujianList.length,
                  itemBuilder: (_, i) {
                    final u = _ujianList[i];
                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.quiz,
                          color: Color(0xFF126998),
                        ),
                        title: Text(u['nama'] ?? ''),
                        subtitle: Text(
                          "${u['mata_pelajaran']?['nama'] ?? 'Mapel'} • ${u['durasi']} menit",
                        ),
                        trailing: const Icon(Icons.play_arrow),
                        onTap: () {
                          Navigator.pop(context);
                          _showSnackBar("Mulai: ${u['nama']}");
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _showNilai() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(24),
          child: _nilaiList.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada nilai",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  controller: controller,
                  itemCount: _nilaiList.length,
                  itemBuilder: (_, i) {
                    final n = _nilaiList[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (n['nilai'] ?? 0) >= 75
                              ? Colors.green
                              : Colors.orange,
                          child: Text(
                            "${n['nilai'] ?? 0}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(n['ujian']?['nama'] ?? 'Ujian'),
                        subtitle: Text(
                          "${n['benar']}/${n['total_soal']} • ${n['created_at']?.toString().split('T').first ?? ''}",
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _showPanduan() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Panduan UjiAja"),
        content: const Text(
          "1. Pilih 'Soal Ulangan' untuk mulai ujian\n"
          "2. Kerjakan soal dengan teliti\n"
          "3. Lihat nilai di menu 'Nilai'\n"
          "4. Keluar dengan tombol logout di kanan atas",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
