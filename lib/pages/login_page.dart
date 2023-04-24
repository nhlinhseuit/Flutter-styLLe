import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool _isCheckedRememberMe = false;
  
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _loadUserEmailPassword();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // REMEMBER ME FEATURE
  void _handleRemeberme(bool? value) {
    _isCheckedRememberMe = value ?? false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('remember_me', _isCheckedRememberMe);
      prefs.setString('email', _email.text);
      prefs.setString('password', _password.text);
    });
    setState(() {
      _isCheckedRememberMe = value ?? false;
    });
  }
  void _loadUserEmailPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? "";
      final password = prefs.getString('password') ?? "";
      final rememberMe = prefs.getBool('remember_me') ?? false;
      if (rememberMe) {
        setState(() {
          _isCheckedRememberMe = true;
        });
        _email.text = email;
        _password.text = password;
      }
    } catch (_) {}
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
          resizeToAvoidBottomInset: false,
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
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: GoogleFonts.abhayaLibre(),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: GoogleFonts.abhayaLibre(),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Theme.of(context).colorScheme.primary,
                              value: _isCheckedRememberMe, 
                              onChanged: _handleRemeberme, 
                              ),
                            Text(
                              "Remember me",
                              style: GoogleFonts.abhayaLibre(),
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(forgotPasswordRoute);
                          }, 
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.abhayaLibre(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 100, 100, 100)
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
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20.00,
                            )
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
                              if (!mounted) return;
                              if (emailVerified) {
                                Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
                              } else {              
                                Navigator.of(context).pushNamedAndRemoveUntil(verifyRoute, (route) => false);
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
                    const SizedBox(
                      height: 4,
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
                        style: Theme.of(context).textTheme.bodyMedium,
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                  }, 
                )
              ],
            )
          ),
        ),
      ]
    );
  }
}