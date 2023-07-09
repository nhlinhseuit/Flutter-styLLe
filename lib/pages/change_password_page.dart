import 'package:flutter/material.dart';
import 'package:stylle/services/auth/auth_exceptions.dart';
import 'package:stylle/services/auth/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.firebase().changePassword(
          currentPassword: _currentPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim());

      // Password changed successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.of(context).pop();

      _currentPasswordController.clear();
      _newPasswordController.clear();
    } on WrongPasswordAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong password.')),
      );
    } on GenericAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication Error.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(children: [
          Container(
            height: MediaQuery.of(context).size.height - 160,
            margin: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Change password",
                  style:
                      TextStyle(fontSize: 30.00, fontWeight: FontWeight.w900),
                ),
                Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Current Password',
                        labelStyle: TextStyle(color: Colors.white60),
                        filled: true,
                        fillColor: Color(0xFF303030),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.white60),
                        filled: true,
                        fillColor: Color(0xFF303030),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // <-- Radius
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: _isLoading ? null : _changePassword,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Confirm',
                              style: TextStyle(
                                color: Colors.black,
                              )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      child: const Text("Cancel",
                          style: TextStyle(
                            fontSize: 16.00,
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
