// lib/screens/pilih_jurusan_hasil_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ujiaja/provider/authProvider.dart';

class PilihJurusanHasilScreen extends ConsumerWidget {
  const PilihJurusanHasilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jurusanAsync = ref.watch(jurusanGuruProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER — HAMPIR SAMA, HANYA JUDUL BERBEDA
            Stack(
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
                    'assets/images/hasil_bg.png',
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
                    onPressed: () => context.pop(),
                  ),
                ),
                const Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Hasil Ulangan',
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
            ),

            // GRID SAMA PERSIS
            Expanded(
              child: jurusanAsync.when(
                data: (list) => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final j = list[i];
                      final color = Color(
                        int.tryParse(
                              j['warna']?.replaceAll('#', '0xFF') ??
                                  '0xFF007AFF',
                            ) ??
                            0xFF007AFF,
                      );

                      return GestureDetector(
                        onTap: () =>
                            context.go('/pilih-kelas/${j['id']}?mode=hasil'),
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
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.bar_chart,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                j['nama'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                error: (_, __) => const Center(
                  child: Text('Error', style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
