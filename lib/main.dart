import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ujiaja/screen/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hdqdhfixicfgpcpvtrbk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhkcWRoZml4aWNmZ3BjcHZ0cmJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyODIyODEsImV4cCI6MjA3OTg1ODI4MX0.L4VMXBr1sE6HjBk-jJvr6qGrEoKu22iQ9elElS9utjs',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
