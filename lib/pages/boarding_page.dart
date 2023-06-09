import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:stylle/constants/routes.dart';

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key});

  @override
  State<BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/Boarding Screen.png",
            fit: BoxFit.cover,
            height: (MediaQuery.of(context).size.height),
            width: (MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: 50,
            right: 0, left: 0,
// Oke chwa?
// a chua, gio muon them 1 dong chu o tren cai box nay thi them 1 cai child moi pk a
            child: Column(
              children: [
                Container(
                  margin:
                      // const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
                      const EdgeInsets.only(
                          top: 35, bottom: 35, left: 45, right: 30),
                  child: Text(
                    "Style is a way to say who you are without having to speak.",
                    style: GoogleFonts.abhayaLibre(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 28.00,
                            fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: SlideAction(
                    height: 75,
                    borderRadius: 25,
                    elevation: 0,
                    // innerColor: ,
                    outerColor: const Color.fromRGBO(217, 217, 217, 0.3),
                    sliderButtonIcon: const Icon(
                      Icons.double_arrow_rounded,
                      color: Colors.black,
                      size: 34,
                    ),
                    text: "Get started",
                    textStyle: GoogleFonts.abhayaLibre(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.00,
                            fontWeight: FontWeight.bold)),
                    sliderRotate: false,
                    onSubmit: () {
                      Navigator.pushNamed(context,preLoginRoute);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getStarted() => Transform.translate(
        offset: Offset(translateX, translateY),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          height: 90,
          width: 100 + myWidth + 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.00),
            color: Colors.white,
          ),
          child: myWidth > 0.0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 30,
                    ),
                    Flexible(
                      child: Text(
                        "  Successfully!",
                        style: TextStyle(color: Colors.green, fontSize: 26.00),
                      ),
                    ),
                  ],
                )
              : const Icon(
                  Icons.double_arrow_rounded,
                  color: Colors.black,
                  size: 50.00,
                ),
        ),
      );

}
