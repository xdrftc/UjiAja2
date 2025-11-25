import 'package:flutter/material.dart';

class DetailKelasScreen extends StatelessWidget {
  final String jurusanNama = "ELEKTRONIKA";
  final String logoPath =
      "assets/icons/tei_big.png"; // logo segitiga merah TEI besar

  const DetailKelasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E40AF), // biru tua atas
              Color(0xFF60A5FA), // biru muda bawah
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Tombol Back
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Logo Jurusan + Nama Jurusan
              Column(
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(logoPath, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    jurusanNama,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Grid Kelas X, XI, XII
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildKelasColumn("X", ["X TEI 1", "X TEI 2", "X TEI 3"]),
                    _buildKelasColumn("XI", [
                      "XI TEI 1",
                      "XI TEI 1",
                      "XI TEI 1",
                    ]), // contoh, sesuaikan
                    _buildKelasColumn("XII", [
                      "XII TEI 1",
                      "XII TEI 1",
                      "XII TEI 1",
                    ]),
                  ],
                ),
              ),

              const Spacer(),

              // Tombol Kembali
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    "Kembali",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKelasColumn(String tingkat, List<String> daftarKelas) {
    return Column(
      children: [
        // Header tingkat (X / XI / XII)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            tingkat,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Daftar kelas per tingkat
        ...daftarKelas
            .map(
              (kelas) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Pindah ke halaman pilihan mata pelajaran atau daftar ujian
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Masuk ke $kelas")));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[900],
                    minimumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    kelas,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
