import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/guru/loginGuru.dart';
import 'package:ujiaja/screen/guru/homescreenGuru.dart';
import 'package:ujiaja/screen/guru/penggunaGuru.dart'; // ProfilGuru
import 'package:ujiaja/screen/guru/buatUlangan.dart'; // BuatUjian
import 'package:ujiaja/screen/guru/daftarSoalUlangan.dart'; // DaftarSoalScreen
import 'package:ujiaja/screen/guru/daftarHasilUlangan.dart'; // DaftarHasilScreen
import 'package:ujiaja/screen/guru/detailjurusan.dart'; // JurusanDetailScreen
import 'package:ujiaja/screen/guru/daftarNilai.dart'; // NilaiListScreen

import 'package:ujiaja/provider/authProvider.dart';
import 'package:ujiaja/screen/siswa/homescreen_siswa/screenUjian.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hdqdhfixicfgpcpvtrbk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhkcWRoZml4aWNmZ3BjcHZ0cmJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyODIyODEsImV4cCI6MjA3OTg1ODI4MX0.L4VMXBr1sE6HjBk-jJvr6qGrEoKu22iQ9elElS9utjs',
  );

  runApp(const ProviderScope(child: MyApp()));
}

// INI SATU-SATUNYA goRouterProvider — BERSIH & BENAR
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/loginGuru',
    routes: [
      GoRoute(
        path: '/loginGuru',
        builder: (context, state) => const LoginGuru(),
      ),
      GoRoute(
        path: '/homescreenGuru',
        builder: (context, state) => const HomescreenGuru(),
      ),
      GoRoute(path: '/pengguna', builder: (context, state) => ProfileGuru()),

      // Pilih Jurusan Buat Soal (Frame 25)
      GoRoute(
        path: '/pilih-jurusan-buat-soal',
        builder: (context, state) => const PilihJurusanBuatSoalScreen(),
      ),

      // Pilih Jurusan Lihat Hasil (Frame 18)
      GoRoute(
        path: '/pilih-jurusan-hasil',
        builder: (context, state) => const PilihJurusanHasilScreen(),
      ),

      // Pilih Kelas
      GoRoute(
        path: '/pilih-kelas/:jurusanId',
        builder: (context, state) {
          final jurusanId = state.pathParameters['jurusanId']!;
          final mode = state.uri.queryParameters['mode'] ?? 'hasil';
          return PilihKelasScreen(jurusanId: jurusanId, mode: mode);
        },
      ),

      // Buat Soal (nanti ganti ke Frame 20)
      GoRoute(
        path: '/buat-soal',
        builder: (context, state) => const BuatSoalScreen(),
      ),

      // Daftar Nilai
      GoRoute(
        path: '/daftar-nilai',
        builder: (context, state) {
          final kelas = state.uri.queryParameters['kelas'] ?? 'X TEI 1';
          final jurusanId = state.uri.queryParameters['jurusanId'] ?? '';
          return DaftarNilaiScreen(kelas: kelas, jurusanId: jurusanId);
        },
      ),
    ],

    redirect: (context, GoRouterState state) {
      final isLoggedIn = authState.user != null;
      final path = state.uri.path;

      if (!isLoggedIn && path != '/loginGuru') return '/loginGuru';
      if (isLoggedIn && path == '/loginGuru') return '/homescreenGuru';

      return null;
    },

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('404 - Halaman tidak ditemukan\n${state.uri}')),
    ),
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key}); // Tambah key biar warning hilang

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'UjiAja - Guru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        fontFamily: 'Poppins',
      ),
      routerConfig: router,
    );
  }
}
