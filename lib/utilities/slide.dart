import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:stylle/constants/routes.dart';

class Slide extends StatefulWidget {
  const Slide({super.key});

  @override
  State<Slide> createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
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
                  fontSize: 30.00,
                  fontWeight: FontWeight.bold)),
          sliderRotate: false,
          onSubmit: () {
            Navigator.pushNamed(context, preLoginRoute);
          },
        ),
      )),
    );
  }
}
