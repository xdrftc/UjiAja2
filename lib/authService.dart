// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  User? user;
  bool isLoading = false;
  String? errorMessage;

  final SupabaseClient _client = Supabase.instance.client;

  bool get isLoggedIn => user != null;

  AuthService() {
    user = _client.auth.currentUser;
    _client.auth.onAuthStateChange.listen((data) {
      user = data.session?.user;
      notifyListeners();
    });
  }

  Future<void> signIn({
    required String nip,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      user = res.user;
      await _client.from('guru').upsert({'id': user!.id, 'nip': nip.trim()});
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    user = null;
    notifyListeners();
  }
}

final authService = AuthService();
