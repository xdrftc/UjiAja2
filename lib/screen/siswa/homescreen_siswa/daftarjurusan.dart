import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detail_kelas_screen.dart'; // ← nanti kamu kirim

final supabase = Supabase.instance.client;

class DaftarKelasScreen extends StatelessWidget {
  const DaftarKelasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ILUSTRASI ===
            _buildHeader(context),

            // === GRID KELAS (REALTIME) ===
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _loadKelasData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error memuat data',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final kelasList = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth < 400
                            ? 2
                            : 3;
                        return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1,
                              ),
                          itemCount: kelasList.length,
                          itemBuilder: (context, index) {
                            final kelas = kelasList[index];
                            return _buildKelasCard(context, kelas);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 280,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E3A8A), Color(0xFF172554)],
            ),
          ),
          child: Image.asset(
            'assets/images/header_illustration.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                'Daftar kelas',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Divider(color: Colors.white70, thickness: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKelasCard(BuildContext context, Map<String, dynamic> kelas) {
    final color = _getColorFromString(kelas['warna'] ?? 'blue');
    final iconUrl = kelas['icon_url'] ?? '';
    final nama = kelas['nama'] ?? 'Kelas';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailKelasScreen(jurusanId: kelas['id']),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: iconUrl.isNotEmpty
                    ? Image.network(
                        iconUrl,
                        width: 45,
                        height: 45,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    : const Icon(Icons.school, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              nama,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'cyan':
        return Colors.cyan;
      case 'blue':
        return Colors.blue;
      case 'indigo':
        return Colors.indigo;
      case 'green':
        return Colors.green;
      case 'teal':
        return Colors.teal;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Future<List<Map<String, dynamic>>> _loadKelasData() async {
    final response = await supabase
        .from('jurusan')
        .select('id, nama, icon_url, warna')
        .order('nama');

    return List<Map<String, dynamic>>.from(response);
  }
}
