import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final w = size.maxWidth;
        final h = size.maxHeight;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              width: w,
              height: h,
              child: Stack(
                children: [
                  // ======== GRADIENT ATAS ========
                  Container(
                    height: h * 0.45,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1EAFFE), Color(0xFF126998)],
                      ),
                    ),
                  ),

                  // ======== LENGKUNG TRANSISI PUTIH ========
                  Positioned(
                    top: h * 0.27,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: h * 0.75,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(120),
                          topRight: Radius.circular(0),
                        ),
                      ),
                    ),
                  ),

                  // ======== GRADIENT BAWAH ========
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: h * 0.11,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xFF1EAFFE), Colors.transparent],
                        ),
                      ),
                    ),
                  ),

                  // ================= KONTEN =================
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: h * 0.08,
                        ), // lebih bawah dari sebelumnya
                        // Judul
                        Text(
                          "UJIAJA",
                          style: TextStyle(
                            fontFamily: "LeckerliOne",
                            fontSize: w * 0.13,
                            color: Colors.white,
                          ),
                        ),

                        // Garis di bawah teks
                        Divider(
                          color: Colors.white,
                          thickness: 2,
                          indent: w * 0.15,
                          endIndent: w * 0.15,
                        ),

                        SizedBox(height: h * 0.01), // jarak kecil ke subteks
                        // Subteks
                        Text(
                          "Silakan login menggunakan nama lengkap dan NIS.",
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: h * 0.15), // jarak ke form login
                        // LOG IN LABEL
                        Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: w * 0.08,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF126998),
                          ),
                        ),

                        SizedBox(height: h * 0.03),

                        // Input Nama
                        inputField("Nama"),

                        SizedBox(height: h * 0.025),

                        // Input NISN
                        inputField("NIP"),

                        SizedBox(height: h * 0.045),

                        // Tombol LOGIN
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF126998),
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.23,
                              vertical: h * 0.018,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ========= TEXTFIELD CUSTOM =========
  Widget inputField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF1EAFFE)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF1EAFFE)),
          ),
        ),
      ),
    );
  }
}
