import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_images.dart';
import 'package:stylle/services/collections/my_users.dart';

class Uploader extends StatefulWidget {
  final File? file;
  final String? description;
  final List<String>? tags;
  const Uploader({super.key, this.file, this.description, this.tags});

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask? _uploadTask;

  void _startUpload() async {
    String filepath = 'images/${DateTime.now()}.png';
    final ref = _storage.ref().child(filepath);

    setState(() {
      _uploadTask = ref.putFile(widget.file!);
    });
    _uploadTask?.whenComplete(() async {
      MyUser? user = await MyUser.getCurrentUser();
      final newImage = MyImage(
        name: filepath, 
        userName: user!.getName, 
        description: widget.description ?? "", 
        tags: widget.tags ?? const ['foryou'], 
        uploadTime: DateTime.now(),
        path: await ref.getDownloadURL(), 
        userEmail: user.email, 
        userID: user.uid, 
        userProfilePic: user.profileImage,
      );
      newImage.createImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder(
        stream: _uploadTask!.snapshotEvents,
        builder: (context, snapshot) {
          var event = snapshot.data;

          double progressPercent = event != null 
            ? event.bytesTransferred / event.totalBytes
            : 0;

          return Column(
            children: [
              if (event?.state == TaskState.success) ...{
                const Text('Congrats!'),
              },
              if (event?.state == TaskState.paused)
                ElevatedButton(
                  onPressed: _uploadTask?.resume, 
                  child: const Icon(Icons.play_arrow)
                ),
              if (event?.state == TaskState.running)
                ElevatedButton(
                  onPressed: _uploadTask?.pause, 
                  child: const Icon(Icons.pause)
                ),

              LinearProgressIndicator(
                value: progressPercent,  
              ),

              Text(
                '${(progressPercent*100).toStringAsFixed(2)}%'
              ),
            ],
          );
        },
      );
    } else {
      // allow user to start the upload if uploadtask is null
      return ElevatedButton.icon(
        onPressed:_startUpload,
        icon: const Icon(Icons.cloud_upload_outlined, color: Colors.black,), 
        label: const Text('Upload', style: TextStyle(color: Colors.black),)
      );
    }
  }
}
