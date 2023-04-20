import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/routes.dart';
import '../utilities/popup_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        // title: const Text("Login"),
      ),
      body: Container(
        margin: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create \nyour new account",
              style: GoogleFonts.abhayaLibre(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 36.00,
                  fontWeight: FontWeight.w900)
              ),
            ),
            Column(
              children: [
                TextField(
                  autofocus: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Your first name',
                    hintStyle: GoogleFonts.abhayaLibre(
                      textStyle: const TextStyle(

                      )
                    )
                  ),
                ),
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Your last name',
                    hintStyle: GoogleFonts.abhayaLibre()
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: GoogleFonts.abhayaLibre()
                  ),
                ),
                TextField(
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.abhayaLibre()
                  ),
                ),
            ],
            ),
            ElevatedButton(
              // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25), // <-- Radius
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                'Sign up',
                style: GoogleFonts.abhayaLibre(
                        textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.00,)
                ),
              ),
              onPressed: () {
                showMessageDialog(context, 'Sign up successfully.');
              }
            ),
            TextButton(
              child: Text(
                "Already have an account? Log in.",
                style: GoogleFonts.abhayaLibre(
                  color: Colors.black,
                  fontSize: 16.00,)
                ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, 
            )
        ],)
      ),
    );
  
  }
}