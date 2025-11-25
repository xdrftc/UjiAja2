import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final w = size.maxWidth;
        final h = size.maxHeight;

        return Scaffold(
          body: Stack(
            children: [
              // GRADIENT BACKGROUND
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1EAFFE), // biru terang (atas)
                      Color(0xFF126998), // biru gelap (bawah)
                    ],
                  ),
                ),
              ),

              // WHITE OVAL BOTTOM
              Positioned(
                bottom: -h * 0.23,
                left: -w * 0.20,
                right: -w * 0.20,
                child: Container(
                  height: h * 0.70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(h * 0.50),
                  ),
                ),
              ),

              // MAIN CONTENT
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: h * 0.05),

                    // TITLE "WELCOME"
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: w * 0.14,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        fontFamily: "GreatVibes",
                      ),
                    ),

                    SizedBox(height: h * 0.015),

                    // SUBTEXT
                    Text(
                      "Selamat datang di aplikasi ujian UJIAJA!!!",
                      style: TextStyle(
                        fontSize: w * 0.035,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: h * 0.03),

                    // BUTTON + TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Silahkan masuk  →  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w * 0.035,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.07,
                              vertical: h * 0.01,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Masuk",
                            style: TextStyle(fontSize: w * 0.035),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // IMAGE
                    // IMAGE
                    Transform.scale(
                      scale:
                          1.3, // semakin besar angkanya → gambar semakin besar
                      child: Image.asset(
                        "assets/welcome.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
