import 'package:flutter/material.dart';
import 'package:stylle/components/circle_image.dart';
import 'package:stylle/components/popup_dialog.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/collections/my_users.dart';

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({super.key});

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: MyUser.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data;
            return ListView(children: [
              Container(
                  height: MediaQuery.of(context).size.height - 160,
                  margin: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Update profile",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 36.00,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Center(
                        child: Stack(
                          children: [
                            CircleImage(size: 80, imgUrl: user!.profileImage),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(50, 0, 0, 0),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(userProfileUploadRoute);
                                  },
                                  icon: const Icon(Icons.camera_alt_outlined)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          TextField(
                            controller: _firstNameController,
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              hintText: 'Your first name',
                            ),
                          ),
                          TextField(
                            controller: _lastNameController,
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              hintText: 'Your last name',
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                          // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25), // <-- Radius
                            ),
                            backgroundColor: Colors.black,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 200, 209),
                              fontSize: 16.00,
                            ),
                          ),
                          onPressed: () async {
                            final firstNameText =
                                _firstNameController.text.trim();
                            final lastNameText =
                                _lastNameController.text.trim();
                            await user.updateInfo(
                                firstName: firstNameText,
                                lastName: lastNameText);
                            await showMessageDialog(context, "Update profile successfully.");
                            Navigator.of(context).pop();
                          }),
                      TextButton(
                        child: const Text("Cancel",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.00,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )),
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
