import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hdqdhfixicfgpcpvtrbk.supabase.co',
    anonKey: 'sb_secret_XsCpGfz1caxDpK12mnzQ0A_LkBxPfkz',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const WelcomePage());
  }
}
