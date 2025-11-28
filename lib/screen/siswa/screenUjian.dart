import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class UjianScreen extends StatefulWidget {
  final String mapelKode;
  final String ujianId;

  const UjianScreen({Key? key, required this.mapelKode, required this.ujianId})
    : super(key: key);

  @override
  State<UjianScreen> createState() => _UjianScreenState();
}

class _UjianScreenState extends State<UjianScreen> {
  late Timer _timer;
  int _secondsRemaining = 0;
  String _selectedAnswer = '';
  late Future<DocumentSnapshot> _soalFuture;

  @override
  void initState() {
    super.initState();
    _soalFuture = _loadSoal();
    _startTimer();
  }

  Future<DocumentSnapshot> _loadSoal() async {
    // Ambil soal pertama dari ujian (bisa diubah jadi list soal)
    final snapshot = await FirebaseFirestore.instance
        .collection('ujian')
        .doc(widget.ujianId)
        .collection('soal')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) throw Exception("Soal tidak ditemukan");
    return snapshot.docs.first;
  }

  void _startTimer() {
    // Misal durasi 10 menit = 600 detik
    _secondsRemaining = 600;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _submitJawaban();
          timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _simpanJawaban(String jawaban) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final soalDoc = await _soalFuture;
    final soalId = soalDoc.id;

    await FirebaseFirestore.instance
        .collection('jawaban')
        .doc('${user.uid}_${widget.ujianId}_$soalId')
        .set({
          'siswaId': user.uid,
          'ujianId': widget.ujianId,
          'soalId': soalId,
          'jawaban': jawaban,
          'waktu': FieldValue.serverTimestamp(),
          'status': _secondsRemaining == 0 ? 'timeout' : 'manual',
        }, SetOptions(merge: true));
  }

  Future<void> _submitJawaban() async {
    await _simpanJawaban(_selectedAnswer);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jawaban disimpan!')));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB), // biru langit
      body: SafeArea(
        child: Column(
          children: [
            // Timer + Back
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'TIMER: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatTime(_secondsRemaining),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Soal Card
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                future: _soalFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error memuat soal',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final pertanyaan = data['pertanyaan'] ?? '';
                  final pilihan = List<String>.from(data['pilihan'] ?? []);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 8),
                            ],
                          ),
                          child: Text(
                            pertanyaan,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Pilihan Ganda
                        ...pilihan.map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => _selectedAnswer = p);
                                _simpanJawaban(p); // Auto-save
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedAnswer == p
                                    ? const Color(0xFF0D47A1)
                                    : Colors.white,
                                foregroundColor: _selectedAnswer == p
                                    ? Colors.white
                                    : Colors.black,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: Color(0xFF0D47A1),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                p,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Tombol Simpan
                        ElevatedButton(
                          onPressed: _submitJawaban,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0D47A1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
