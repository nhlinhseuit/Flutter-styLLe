import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/utilities/popup_dialog.dart';

import '../constants/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              "Log into \nyour account",
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
                  controller: _email,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: GoogleFonts.abhayaLibre()
                  ),
                ),
                TextField(
                  controller: _password,
                  autofocus: true,
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.abhayaLibre()
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (bool? value) {}, ),
                        Text(
                          "Remember me",
                          style: GoogleFonts.abhayaLibre(),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {}, 
                      child: Text(
                        "Forgot password?",
                        style: GoogleFonts.abhayaLibre(
                            color: const Color.fromARGB(255, 160, 160, 160)
                        ),
                      )
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
              // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // <-- Radius
                      ),
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      'Log in',
                      style: GoogleFonts.abhayaLibre(
                              textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.00,)
                      ),
                    ),
                    onPressed: () {
                      showMessageDialog(context, 'Log in succ essfully.');
                    }
                  ),
                ),
                ElevatedButton.icon(
              // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // <-- Radius
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  label: Text(
                    'Log in with Facebook',
                    style: GoogleFonts.abhayaLibre(
                            textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.00,)
                    ),
                  ),
                  onPressed: () {
                    showMessageDialog(context, 'Log in with Facebook succ essfully.');
                  }, 
                  icon: const Icon(
                    Icons.facebook,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            TextButton(
              child: Text(
                "New to this app? Sign up.",
                style: GoogleFonts.abhayaLibre(
                  color: Colors.black,
                  fontSize: 16.00,)
                ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }, 
            )
        ],)
      ),
    );
  }
}