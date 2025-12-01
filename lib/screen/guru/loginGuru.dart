// lib/screen/guru/login_guru.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/guru/homescreenGuru.dart';

final supabase = Supabase.instance.client;

class LoginGuru extends StatefulWidget {
  const LoginGuru({super.key});
  @override
  State<LoginGuru> createState() => _LoginGuruState();
}

class _LoginGuruState extends State<LoginGuru> {
  final _nipController = TextEditingController();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedMapel;
  List<String> _mapelList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMapel();
  }

  Future<void> _loadMapel() async {
    final res = await supabase
        .from('mata_pelajaran')
        .select('nama')
        .order('nama');
    setState(() => _mapelList = res.map((e) => e['nama'] as String).toList());
  }

  Future<void> _loginOrRegister() async {
    final nip = _nipController.text.trim();
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (nip.length != 18 || !RegExp(r'^\d+$').hasMatch(nip)) {
      _showSnack("NIP harus 18 digit angka");
      return;
    }
    if (nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _selectedMapel == null) {
      _showSnack("Semua field wajib diisi");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final existing = await supabase
          .from('guru')
          .select()
          .eq('nip', nip)
          .maybeSingle();

      if (existing != null) {
        final data = existing as Map;
        if (data['nama'] != nama || data['email'] != email) {
          _showSnack("Data tidak sesuai");
          return;
        }
      }

      try {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } on AuthException catch (e) {
        if (e.message.contains('Invalid')) {
          await supabase.auth.signUp(
            email: email,
            password: password,
            data: {
              'nip': nip,
              'nama': nama,
              'mata_pelajaran': _selectedMapel,
              'role': 'guru',
            },
          );
        } else {
          rethrow;
        }
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomescreenGuru()),
        );
      }
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'UjiAja',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontFamily: 'LeckerliOne',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF126998),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _textField(
                          "NIP",
                          _nipController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _textField("Nama Lengkap", _namaController),
                        const SizedBox(height: 16),
                        _dropdown(
                          "Mata Pelajaran",
                          _selectedMapel,
                          _mapelList,
                          (v) => setState(() => _selectedMapel = v),
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          "Email",
                          _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          "Password",
                          _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _loginOrRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF126998),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 60,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "LOGIN",
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
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF1EAFFE)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text("Pilih $label"),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF1EAFFE)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
        ),
      ),
    );
  }
}
