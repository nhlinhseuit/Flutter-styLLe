import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stylle/services/notifiers/current_user.dart';

import '../constants/routes.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../components/popup_dialog.dart';
import '../services/collections/my_users.dart';
import '../utilities/check_connectivity.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController; 
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
            // resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              // title: const Text("Login"),
            ),
            body: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 160,
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
                          controller: _firstNameController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'Your first name',
                            hintStyle: GoogleFonts.abhayaLibre()
                          ),
                        ),
                        TextField(
                          controller: _lastNameController,
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: GoogleFonts.abhayaLibre(),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: GoogleFonts.abhayaLibre(),
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),
                        TextField(
                          controller: _confirmPasswordController,
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
                        if (!(await checkInternetConnectivity())) {
                          displayNoInternet();
                          return;
                        }
                        final emailText = _emailController.text.trim();
                        final passwordText = _passwordController.text.trim();
                        final firstNameText = _firstNameController.text.trim();
                        final lastNameText = _lastNameController.text.trim();
                        final confirmPasswordText = _confirmPasswordController.text.trim();
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
                          Provider.of<CurrentUser>(context,
                                                listen: false)
                                            .user =
                                        (await MyUser.getCurrentUser())!;
                          if (!mounted) return;
                          Navigator.of(context).pushNamed(verifyRoute);
                        } on WeakPasswordAuthException {
                          await showMessageDialog(context, 'Your password is not strong enough.');
                        } on EmailAlreadyInUseAuthException {
                          await showMessageDialog(context, 'Email already in use.');
                        } on InvalidEmailAuthException {
                          await showMessageDialog(context, 'Invalid email.');
                        } on GenericAuthException {
                          await showMessageDialog(context, 'Authentication error.');
                        } catch (e) {
                            await showMessageDialog(context, 'Error: ${e.toString()}', title: 'Something went wrong');
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
              ]
            ),
          ),
        ],
    );
  }
}