import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/pages/boarding_page.dart';
import 'package:stylle/pages/login_page.dart';

import '../constants/routes.dart';

class PreLoginPage extends StatefulWidget {
  const PreLoginPage({super.key});

  @override
  State<PreLoginPage> createState() => _PreLoginPageState();
}

class _PreLoginPageState extends State<PreLoginPage> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/Pre Screen.png",
            fit: BoxFit.fill,
            height: (MediaQuery.of(context).size.height),
            width: (MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: Column(
              children: [

                // BUTTON 1

                Center(
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 60),
                    height: 55,
                    child: ElevatedButton(
                      // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // <-- Radius
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'LOG IN',
                        style: GoogleFonts.abhayaLibre(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.00,
                                fontWeight: FontWeight.w900)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(loginRoute);
                      },
                    ),
                  ),
                ),

                // BUTTON 2

                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: (MediaQuery.of(context).size.width - 60),
                    height: 55,
                    child: OutlinedButton(
                      // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                      
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 2.0, color: Color.fromRGBO(217, 217, 217, 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // <-- Radius
                        ),
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 0.2),
                      ),
                      child: Text(
                        'CREATE NEW ACCOUNT',
                        style: GoogleFonts.abhayaLibre(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.00,
                                fontWeight: FontWeight.w900)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(registerRoute);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
