// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider utama Supabase client
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// State untuk Auth (user & loading)
// lib/providers/auth_provider.dart  ← GANTI BAGIAN INI SAJA

class AuthState {
  final User? user; // ← ini yang dipakai
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.user, // ← user langsung di sini
    this.isLoading = false,
    this.errorMessage,
  });

  // Tambahkan getter biar bisa pakai currentUser (opsional, tapi banyak yang suka)
  User? get currentUser => user;

  AuthState copyWith({User? user, bool? isLoading, String? errorMessage}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Auth Notifier – semua logika login, signup, dan query guru
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._client) : super(AuthState()) {
    // Listen perubahan sesi secara real-time
    _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final user = session?.user;
      state = state.copyWith(user: user, isLoading: false, errorMessage: null);
    });
  }

  final SupabaseClient _client;

  User? get currentUser => state.user;

  /// Login guru dengan NIP + Email + Password
  Future<void> signIn({
    required String nip,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      // Pastikan NIP tersimpan di tabel guru (jika belum ada)
      final guruExists = await _client
          .from('guru')
          .select('id')
          .eq('id', response.user!.id)
          .maybeSingle();

      if (guruExists == null) {
        await _client.from('guru').insert({
          'id': response.user!.id,
          'nip': nip.trim(),
        });
      } else if ((guruExists as Map<String, dynamic>)['nip'] != nip.trim()) {
        await _client
            .from('guru')
            .update({'nip': nip.trim()})
            .eq('id', response.user!.id);
      }

      state = state.copyWith(user: response.user, isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  /// Sign Up guru (untuk admin yang mau tambah guru baru)
  Future<void> signUp({
    required String nama,
    required String nip,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'nama': nama.trim(), 'role': 'guru'},
      );

      // Otomatis buat row di tabel guru
      await _client.from('guru').insert({
        'id': response.user!.id,
        'nip': nip.trim(),
      });

      state = state.copyWith(user: response.user, isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  /// Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
    state = state.copyWith(user: null);
  }

  /// Ambil semua jurusan yang diampu guru ini
  Future<List<Map<String, dynamic>>> getJurusanGuru() async {
    if (state.user == null) return [];

    final data = await _client
        .from('guru_jurusan')
        .select('jurusan: jurusan_id (id, nama, logo_url, warna)')
        .eq('guru_id', state.user!.id);

    return data.map((row) => row['jurusan'] as Map<String, dynamic>).toList();
  }

  /// Ambil daftar hasil ulangan (untuk screen Daftar Nilai)
  Future<List<Map<String, dynamic>>> getHasilUlangan({
    required String ujianId,
    required String kelas,
  }) async {
    return await _client
        .from('hasil')
        .select('''
          nilai, benar, total_soal,
          siswa_nisn,
          siswa:siswa_nisn (nama)
        ''')
        .eq('ujian_id', ujianId)
        .eq('kelas', kelas)
        .order('nilai', ascending: false);
  }

  /// Ambil data profil guru (untuk screen Profil)
  Future<Map<String, dynamic>?> getProfileGuru() async {
    if (state.user == null) return null;

    final data = await _client
        .from('profiles')
        .select('*, guru!inner(nip, foto_url)')
        .eq('id', state.user!.id)
        .single();

    return data;
  }
}

/// Provider utama AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final client = ref.watch(supabaseProvider);
  return AuthNotifier(client);
});

/// Provider untuk daftar jurusan yang diampu guru (LOGO DARI LOKAL!)
final jurusanGuruProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];

  // Ambil data jurusan dari Supabase (cuma id, nama, warna)
  final response = await Supabase.instance.client
      .from('guru_jurusan')
      .select('jurusan:jurusan_id (id, nama, warna)')
      .eq('guru_id', userId);

  // Ubah jadi format yang siap pakai + tambah path logo lokal
  return response.map((item) {
    final jurusan = item['jurusan'] as Map<String, dynamic>;
    final nama = jurusan['nama'] as String;
    final namaFile = nama.toLowerCase().replaceAll(
      ' ',
      '',
    ); // tei, rpl, tkj, dll

    return {
      'id': jurusan['id'],
      'nama': nama,
      'warna': jurusan['warna'] ?? '#007AFF', // fallback biru kalau null
      // Logo diambil dari assets lokal → TIDAK PAKAI INTERNET SAMA SEKALI
    };
  }).toList();
});
