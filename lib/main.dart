import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/welcome.dart';
import 'package:ujiaja/createSiswaAccount.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hdqdhfixicfgpcpvtrbk.supabase.co',
    anonKey: 'sb_secret_XsCpGfz1caxDpK12mnzQ0A_LkBxPfkz',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  await createSiswaAccounts();

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
