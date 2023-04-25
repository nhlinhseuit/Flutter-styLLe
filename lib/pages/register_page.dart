import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/routes.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../utilities/popup_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _firstName.dispose();
    _lastName.dispose();
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
        Scaffold(
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
                      controller: _firstName,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Your first name',
                        hintStyle: GoogleFonts.abhayaLibre()
                      ),
                    ),
                    TextField(
                      controller: _lastName,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Your last name',
                        hintStyle: GoogleFonts.abhayaLibre()
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
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
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: GoogleFonts.abhayaLibre(),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    TextField(
                      controller: _confirmPassword,
                      obscureText: true,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        hintStyle: GoogleFonts.abhayaLibre(),
                        prefixIcon: const Icon(Icons.lock),
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
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    'Sign up',
                    style: GoogleFonts.abhayaLibre(
                            textStyle: const TextStyle(
                            color: Color.fromARGB(255, 252, 200, 209),
                            fontSize: 20.00,)
                    ),
                  ),
                  onPressed: () async {
                    final emailText = _email.text;
                    final passwordText = _password.text;
                    final firstNameText = _firstName.text;
                    final lastNameText = _lastName.text;
                    final confirmPasswordText = _confirmPassword.text;
                    if (passwordText != confirmPasswordText) {
                      await showMessageDialog(context, 'Passwords do not match.');
                      return;
                    }
                    try {
                      await AuthService.firebase().createUser(
                        email: emailText, 
                        password: passwordText, 
                        firstName: firstNameText, 
                        lastName: lastNameText,
                      );
                      AuthService.firebase().sendEmailVerification();
                      if (!mounted) return;
                      Navigator.of(context).pushNamed(verifyRoute);
                    } on WeakPasswordAuthException {
                      await showMessageDialog(context, 'Babe, your password is not strong enough.');
                    } on EmailAlreadyInUseAuthException {
                      await showMessageDialog(context, 'Babe, your email is already in use.');
                    } on InvalidEmailAuthException {
                      await showMessageDialog(context, 'Babe, your email is invalid.');
                    } on GenericAuthException {
                      await showMessageDialog(context, 'Authentication error.');
                    } catch (e) {
                        await showMessageDialog(context, 'Error: ${e.toString()}');
                    }
                  } 
                ),
                TextButton(
                  child: Text(
                    "Already have an account? Log in.",
                    style: GoogleFonts.abhayaLibre(
                      color: Colors.black,
                      fontSize: 16.00,
                    )
                  ),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(loginRoute);
                  }, 
                )
            ],)
          ),
        ),
      ],
    );
  }
}