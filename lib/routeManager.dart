// lib/route_manager.dart
import 'package:flutter/material.dart';
import 'package:ujiaja/authService.dart';

import 'package:ujiaja/screen/welcome2.dart';
import 'package:ujiaja/screen/welcome.dart';
import 'package:ujiaja/screen/guru/loginguru.dart';
import 'package:ujiaja/screen/guru/homescreenGuru.dart';
import 'package:ujiaja/screen/guru/penggunaGuru.dart';
import 'package:ujiaja/screen/guru/buatUlangan.dart';
import 'package:ujiaja/screen/guru/daftarSoalUlangan.dart';
import 'package:ujiaja/screen/guru/daftarHasilUlangan.dart';
import 'package:ujiaja/screen/guru/detailjurusan.dart';
import 'package:ujiaja/screen/guru/daftarNilai.dart';

class RouteManager extends StatelessWidget {
  const RouteManager({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authService,
      builder: (context, child) {
        // LOGIC SAMA PERSIS SEPERTI GoRouter.redirect
        if (!authService.isLoggedIn) {
          return const WelcomePage(); // atau langsung LoginGuru()
        }
      },
    );
  }
}
