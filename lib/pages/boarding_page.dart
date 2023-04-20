import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            fit: BoxFit.fill,
            height: (MediaQuery.of(context).size.height),
            width: (MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: 100,
            right: 0, left: 0,
// Oke chwa?
// a chua, gio muon them 1 dong chu o tren cai box nay thi them 1 cai child moi pk a
            child: Column(
              children: [
                Container(
                  margin:
                      // const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
                      const EdgeInsets.only(top: 35, bottom: 35, left: 45, right: 30),
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.00),
                    color: const Color.fromRGBO(217, 217, 217, 0.3),
                  ),
                  // width: MediaQuery.of(context).size.width - 100,
                  height: 90,
                  margin: const EdgeInsets.symmetric(horizontal: 40),

                  child: GestureDetector(
                    onHorizontalDragUpdate: (event) async {
                      if (event.primaryDelta! > 10) {
                        _incTansXVal();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getStarted(),
                        myWidth == 0.0
                            ?  Expanded(
                                child: Center(
                                  child: Text(
                                    "Get started",
                                    style: GoogleFonts.abhayaLibre(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30.00,
                                            fontWeight: FontWeight.bold)),
                                    // style: TextStyle(
                                    //     color: Colors.white, fontSize: 23.00),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
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
                        style: TextStyle(color: Colors.green, fontSize: 26.00, fontWeight: FontWeight.w600),
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

  _incTansXVal() async {
    int canLoop = -1;
    for (var i = 0; canLoop == -1; i++) {
      await Future.delayed(const Duration(milliseconds: 1), () {
        setState(() {
          if (translateX + 1 <
              MediaQuery.of(context).size.width - (200 + myWidth)) {
            translateX += 1;
            myWidth = MediaQuery.of(context).size.width - (200 + myWidth);
          } else {
            setState(() {
              canLoop = 1;
            });
          }
        });
      });
    }
  }
}
