import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/components/popup_dialog.dart';

import '../services/auth/auth_exceptions.dart';
import '../utilities/check_connectivity.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailController;
  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    String email = _emailController.text.trim();

    if (email.isNotEmpty) {
      try {
        await AuthService.firebase().sendPasswordResetEmail(email: email);
        await showMessageDialog(context, 'Please check your email to reset your password.');
        Navigator.of(context).pop();
      } on UserNotFoundAuthException {
        var snackBar = const SnackBar(content: Text('User not found.\nMake sure your email has been registered.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on InvalidEmailAuthException {
        var snackBar = const SnackBar(content: Text('Invalid email.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        var snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      // Show an error message to the user
    }
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
                ElevatedButton(
                  // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // <-- Radius
                    ),
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: resetPassword,
                  child: Text(
                    'Reset Password',
                    style: GoogleFonts.abhayaLibre(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20.00,
                      )
                    ),
                  ),
                ),
                const SizedBox(
                  height: 120,
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}