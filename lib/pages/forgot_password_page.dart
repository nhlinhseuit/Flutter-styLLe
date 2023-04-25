import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/LoginBackground.png",
          fit: BoxFit.fill,
          height: (MediaQuery.of(context).size.height),
          width: (MediaQuery.of(context).size.width),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          body: Container(
            margin: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reset\npassword",
                  style: GoogleFonts.abhayaLibre(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 36.00,
                      fontWeight: FontWeight.w900)
                  ),
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}