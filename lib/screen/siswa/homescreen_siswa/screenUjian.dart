// lib/screen/siswa/screen_ujian.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HasilujianScreen.dart';
import 'package:ujiaja/timeController.dart';
import 'dart:async';

final supabase = Supabase.instance.client;

class UjianScreen extends StatefulWidget {
  final String ujianId;
  const UjianScreen({super.key, required this.ujianId});

  @override
  State<UjianScreen> createState() => _UjianScreenState();
}

class _UjianScreenState extends State<UjianScreen> {
  late final TimerController _timerController;
  int _currentIndex = 0;
  List<Map<String, dynamic>> _soalList = [];
  final Map<String, String> _jawabanMap = {};
  Timer? _debounce;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUjian();
  }

  Future<void> _loadUjian() async {
    final ujian = await supabase
        .from('ujian')
        .select('durasi')
        .eq('id', widget.ujianId)
        .single();

    final durasiDetik = (ujian['durasi'] as int) * 60;

    // INISIALISASI TIMER
    _timerController = TimerController(durasiDetik);
    _timerController.addListener(() {
      if (_timerController.value == 0) {
        _submitUjian();
      }
    });
    _timerController.start();

    final soal = await supabase
        .from('soal')
        .select()
        .eq('ujian_id', widget.ujianId)
        .order('id');

    setState(() {
      _soalList = List<Map<String, dynamic>>.from(soal);
      _isLoading = false;
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _simpanJawaban(String soalId, String jawaban) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      final userNisn = supabase.auth.currentUser?.id;
      if (userNisn == null) return;

      await supabase.from('jawaban').upsert({
        'siswa_nisn': userNisn,
        'soal_id': soalId,
        'jawaban': jawaban,
        'status': 'manual',
      }, onConflict: 'siswa_nisn,soal_id');
    });

    setState(() {
      _jawabanMap[soalId] = jawaban;
    });
  }

  Future<void> _submitUjian() async {
    if (_soalList.isEmpty) return;

    int benar = 0;
    for (var soal in _soalList) {
      final jawabanSiswa = _jawabanMap[soal['id'].toString()];
      if (jawabanSiswa == soal['jawaban_benar']) benar++;
    }

    final nilai = (_soalList.isEmpty)
        ? 0
        : (benar / _soalList.length * 100).round();

    final userNisn = supabase.auth.currentUser?.id;
    await supabase.from('hasil').upsert({
      'siswa_nisn': userNisn,
      'ujian_id': widget.ujianId,
      'nilai': nilai,
      'benar': benar,
      'total_soal': _soalList.length,
    }, onConflict: 'siswa_nisn,ujian_id');

    _timerController.stop();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HasilUjianScreen(
            nilai: nilai,
            benar: benar,
            total: _soalList.length,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final soal = _soalList[_currentIndex];
    final pilihan = List<String>.from(soal['pilihan']);
    final selected = _jawabanMap[soal['id'].toString()];

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Soal ${_currentIndex + 1}/${_soalList.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // TIMER PAKAI ValueListenableBuilder → HANYA UPDATE ANGKA!
                  ValueListenableBuilder<int>(
                    valueListenable: _timerController,
                    builder: (context, seconds, _) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'TIMER: ${_formatTime(seconds)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        soal['pertanyaan'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ...pilihan.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          onPressed: () =>
                              _simpanJawaban(soal['id'].toString(), p),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selected == p
                                ? const Color(0xFF0D47A1)
                                : Colors.white,
                            foregroundColor: selected == p
                                ? Colors.white
                                : Colors.black,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Color(0xFF0D47A1),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(p, style: const TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentIndex > 0)
                          TextButton(
                            onPressed: () => setState(() => _currentIndex--),
                            child: const Text(
                              'Sebelumnya',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        else
                          const SizedBox(width: 80),
                        ElevatedButton(
                          onPressed: _currentIndex < _soalList.length - 1
                              ? () => setState(() => _currentIndex++)
                              : _submitUjian,
                          child: Text(
                            _currentIndex < _soalList.length - 1
                                ? 'Berikutnya'
                                : 'Selesai',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
