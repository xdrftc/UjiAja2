// lib/screen/siswa/pengguna_siswa.dart
import 'package:flutter/material.dart';

class PenggunaSiswaPage extends StatelessWidget {
  final Map<String, dynamic> siswa;

  const PenggunaSiswaPage({super.key, required this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF126998),
        elevation: 0,
        title: const Text(
          "Profil Pengguna",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // HEADER BIRU MELENGKUNG
          Container(
            width: double.infinity,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFF126998),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFF126998)),
                ),
                SizedBox(height: 8),
                Text(
                  "Pengguna",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // FORM PROFIL (READ ONLY)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildInfoField("Nama", siswa['nama'] ?? '-'),
                const SizedBox(height: 16),
                _buildInfoField("Nisn", siswa['nisn'] ?? '-'),
                const SizedBox(height: 16),
                _buildInfoField("Kelas", siswa['kelas'] ?? '-'),
                const SizedBox(height: 16),
                _buildInfoField("Jurusan", siswa['jurusan'] ?? '-'),
                const SizedBox(height: 16),
                _buildInfoField("Email", siswa['email'] ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1EAFFE), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF126998)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
