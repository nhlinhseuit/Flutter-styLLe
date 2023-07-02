import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../components/popup_dialog.dart';
import '../services/collections/my_users.dart';

class UserProfileUpload extends StatefulWidget {
  const UserProfileUpload({super.key});

  @override
  State<UserProfileUpload> createState() => _UserProfileUploadState();
}

class _UserProfileUploadState extends State<UserProfileUpload> {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask? _uploadTask;

  void _startUpload() async {
    final user = (await MyUser.getCurrentUser())!;
    String filepath = 'user_profiles/${user.uid}.png';
    final ref = _storage.ref().child(filepath);

    setState(() {
      _uploadTask = ref.putFile(_imageFile!);
    });
    _uploadTask?.whenComplete(() async {
      final imagePath = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users')
      .doc(user.uid)
      .update({
        'profile_image': imagePath
      })
      .catchError((error) async {
        await showMessageDialog(context, "Failed to upload profile image: $error");
        await _storage.ref().child(filepath).delete();
        return;
      });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('images')
          .where('user_info.id', isEqualTo: user.uid)
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot doc) async {
        DocumentReference documentRef = doc.reference;
        print(documentRef);
        try {
          await documentRef.update({
            'user_info.profile': imagePath, 
          });
          print('Document successfully updated!');
        } catch (error) {
          print('Error updating document: $error');
        }
      });
      await showMessageDialog(context, "Update successdully!", title: 'Congrats');
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await _picker.pickImage(
      source: source,
      maxWidth: 200,
    );

    setState(() {
      _imageFile = selected == null ? _imageFile : File(selected.path);
    });
  }

  Future<void> _cropImage() async {
    CroppedFile? cropped = await  _cropper.cropImage(
      sourcePath: _imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ]
    );

    setState(() {
      _imageFile = cropped == null ? _imageFile : File(cropped.path);
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async { 
        setState(() {
          _imageFile = null;
        });
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false
        ),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            padding: const EdgeInsets.only(top: 0),
            children: <Widget>[
              if (_imageFile == null) Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Change profile pic",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.00,
                          )
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16
                          ),
                        )
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25), // <-- Radius
                              ),
                              minimumSize: Size(MediaQuery.of(context).size.width / 2.6, 120),
                            ),
                            child: const Icon(Icons.camera_alt_outlined),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text('Camera'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25), // <-- Radius
                              ),
                              minimumSize: Size(MediaQuery.of(context).size.width / 2.6, 120),
                            ),
                            child: const Icon(Icons.image_search),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text('Gallery'),
                        ],
                      ),
                    ],
                  ),
                ],
              ) else ...[
                Image.file(_imageFile!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _cropImage,
                      child: const Icon(Icons.crop),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    ElevatedButton(
                      onPressed: _clear,
                      child: const Icon(Icons.refresh),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton.icon(
                  onPressed:_startUpload,
                  icon: const Icon(Icons.cloud_upload_outlined), 
                  label: const Text('Upload')
                ),
              ]
            ]
          )
        ),
      ),
    );
  }
}
