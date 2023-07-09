import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stylle/components/popup_dialog.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/utilities/check_connectivity.dart';

class UserProfileUploader extends StatefulWidget {
  final File? file;
  final String? description;
  final List<String>? tags;
  const UserProfileUploader(
      {super.key, this.file, this.description, this.tags});

  @override
  State<UserProfileUploader> createState() => _UserProfileUploaderState();
}

class _UserProfileUploaderState extends State<UserProfileUploader> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask? _uploadTask;

  void _startUpload() async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    final user = (await MyUser.getCurrentUser())!;
    String filepath = 'user_profiles/${user.uid}.png';
    final ref = _storage.ref().child(filepath);

    setState(() {
      _uploadTask = ref.putFile(widget.file!);
    });
    _uploadTask?.whenComplete(() async {
      final imagePath = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profile_image': imagePath}).catchError(
              (error) => showMessageDialog(
                  context, "Failed to upload profile image: $error"));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder(
        stream: _uploadTask!.snapshotEvents,
        builder: (context, snapshot) {
          var event = snapshot.data;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalBytes : 0;

          return Column(
            children: [
              if (event?.state == TaskState.success) ...{
                const Text('Congrats!'),
              },
              if (event?.state == TaskState.paused)
                ElevatedButton(
                    onPressed: _uploadTask?.resume,
                    child: const Icon(Icons.play_arrow)),
              if (event?.state == TaskState.running)
                ElevatedButton(
                    onPressed: _uploadTask?.pause,
                    child: const Icon(Icons.pause)),
              LinearProgressIndicator(
                value: progressPercent,
              ),
              Text('${(progressPercent * 100).toStringAsFixed(2)}%'),
            ],
          );
        },
      );
    } else {
      // allow user to start the upload if uploadtask is null
      return ElevatedButton.icon(
          onPressed: _startUpload,
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('Upload'));
    }
  }
}
