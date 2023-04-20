import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/utilities/popup_dialog.dart';

import '../constants/routes.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;

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
    return Stack(
      children: [
        Image.asset(
          "assets/images/LoginBackground.png",
          fit: BoxFit.fill,
          height: (MediaQuery.of(context).size.height),
          width: (MediaQuery.of(context).size.width),
        ),
        Scaffold ( 
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
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
                        enableSuggestions: false,
                        autocorrect: false,
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
                          onPressed: () async {
                            final emailText = _email.text;
                            final passwordText = _password.text;
                            
                            try {
                              await AuthService.firebase().login(
                                email: emailText, 
                                password: passwordText
                              );
                              final user = AuthService.firebase().currentUser;
                              if (user != null) {
                                final emailVerified = user.isEmailVerified;
                                if (emailVerified) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
                                } else {              
                                  // Navigator.of(context).pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                                }
                              }         
                            } on UserNotFoundAuthException {
                              await showMessageDialog(context, 'Babe, who even are you?');
                            } on WrongPasswordAuthException {
                              await showMessageDialog(context, 'Babe, wrong password.');
                            } on GenericAuthException {
                              await showMessageDialog(context, 'Authentication Error.');
                            }
                            catch (e) {
                              await showMessageDialog(context, 'Error: ${e.toString()}');
                            }
                          }
                        )
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
        ),
      ]
    );
  }
}