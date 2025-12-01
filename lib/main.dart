import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/guru/loginGuru.dart';
import 'package:ujiaja/screen/guru/homescreenGuru.dart';
import 'package:ujiaja/screen/guru/penggunaGuru.dart';
import 'package:ujiaja/screen/guru/buatUlangan.dart';
import 'package:ujiaja/screen/guru/daftarHasilUlangan.dart'; // Untuk pilih jurusan (soal/hasil)
import 'package:ujiaja/screen/guru/daftarSoalUlangan.dart'; // Detail jurusan & pilih kelas
import 'package:ujiaja/screen/guru/detailjurusan.dart'; // Daftar nilai
import 'package:ujiaja/provider/authProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:
        'https://hdqdhfixicfgpcpvtrbk.supabase.co', // Ganti dengan URL proyekmu
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhkcWRoZml4aWNmZ3BjcHZ0cmJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyODIyODEsImV4cCI6MjA3OTg1ODI4MX0.L4VMXBr1sE6HjBk-jJvr6qGrEoKu22iQ9elElS9utjs', // Ganti dengan Anon Key
  );
  runApp(ProviderScope(child: MyApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.watch(authProvider);
  final goRouterProvider = Provider<GoRouter>((ref) {
    final authState = ref.watch(authProvider); // dari auth_provider.dart

    return GoRouter(
      initialLocation: '/loginGuru',

      routes: [
        // 1. Login Guru
        GoRoute(
          path: '/loginGuru',
          builder: (context, state) => const LoginGuru(),
        ),

        // 2. Homescreen / Dashboard Guru
        GoRoute(
          path: '/homescreenGuru',
          builder: (context, state) => const HomescreenGuru(),
        ),

        // 3. Profil Guru
        GoRoute(
          path: '/pengguna',
          builder: (context, state) => const ProfilGuru(),
        ),

        // 4. Buat Soal / Ujian
        GoRoute(
          path: '/create-question',
          builder: (context, state) => const BuatUjian(),
        ),

        // 5. Pilih Jurusan (untuk buat soal atau lihat hasil)
        GoRoute(
          path: '/pilih-jurusan-buat-soal',
          name: 'pilihJurusanBuatSoal',
          builder: (context, state) => const DaftarSoalScreen(),
        ),
        GoRoute(
          path: '/pilih-jurusan-hasil',
          name: 'pilihJurusanHasil',
          builder: (context, state) => const DaftarHasilScreen(),
        ),

        // 6. Pilih Kelas di Jurusan tertentu
        GoRoute(
          path: '/jurusan/:jurusanId/kelas',
          builder: (context, state) {
            final jurusanId = state.pathParameters['jurusanId']!;
            return JurusanDetailScreen(jurusanId: jurusanId);
          },
        ),

        // 7. Daftar Nilai per Ujian & Kelas
        GoRoute(
          path: '/nilai/:ujianId/:kelas',
          builder: (context, state) {
            final ujianId = state.pathParameters['ujianId']!;
            final kelas = state.pathParameters['kelas']!;
            return NilaiListScreen(ujianId: ujianId, kelas: kelas);
          },
        ),
      ],

      // REDIRECT LOGIC – INI YANG PALING PENTING!
      redirect: (context, state) {
        final isLoggedIn = authState.user != null;
        final currentPath = state.uri.path;

        // 1. Belum login → paksa ke loginGuru
        if (!isLoggedIn && currentPath != '/loginGuru') {
          return '/loginGuru';
        }

        // 2. Sudah login + lagi di halaman login → arahkan ke homescreenGuru
        if (isLoggedIn && currentPath == '/loginGuru') {
          return '/homescreenGuru';
        }

        // 3. (Opsional) Kalau mau lebih ketat: cek role dari metadata
        // final role = authState.user?.userMetadata?['role'] ?? 'siswa';
        // if (isLoggedIn && role != 'guru' && role != 'admin') {
        //   return '/loginGuru'; // atau halaman "Akses Ditolak"
        // }

        // Kalau tidak ada redirect → lanjut ke route yang diminta
        return null;
      },

      // (Opsional) Error page kalau route tidak ditemukan
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Halaman tidak ditemukan: ${state.uri}')),
      ),
    );
  });
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'UjiAja Guru',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: router,
    );
  }
}
