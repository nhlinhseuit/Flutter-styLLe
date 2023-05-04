import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_users.dart';

import '../../utilities/popup_dialog.dart';

class MyImage {
  String id;
  final String path;
  final String userName;
  final String description;
  final List<String> tags;
  late bool deleted;

  static CollectionReference dbImages = FirebaseFirestore.instance.collection('images');

  MyImage({
    this.id = '',
    required this.path,
    required this.userName,
    this.description = '', 
    this.tags = const ['foryou'],
    this.deleted = false,
  });

  Future<void> createImage() {
    final imageDoc = dbImages.doc();
    id = imageDoc.id;
    final imageData = toJson();
    // Call the user's CollectionReference to add a new user
    return imageDoc.set(imageData)
        .then((value) => print("Image Added"))
        .catchError((error) => print("Failed to add image: $error"));
  }

  static Stream<List<MyImage>> readImgaes() => FirebaseFirestore.instance
    .collection('images')
    .snapshots()
    .map((snapshot) => snapshot.docs.map(
      (doc) => MyImage.fromJson(doc.data()))
    .toList()
    );
    

  static Future<MyImage?> readImage({required String? id}) async {
    final docUser = FirebaseFirestore.instance.collection('images').doc(id);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return MyImage.fromJson(snapshot.data()!);
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': path,
    'user_name': userName,
    'description': description,
    'tags': tags,
    'deleted': deleted,
  };
  static MyImage fromJson(Map<String,dynamic> json) => MyImage(
    id: json['id'], 
    path: json['name'],
    userName: json['user_name'], 
    description: json['description'],
    tags: List<String>.from(json['tags']),
    deleted: json['deleted']
  );
}

//// Upload Image Widget ////

class Uploader extends StatefulWidget {
  File? file;
  final String? description;
  final List<String>? tags;
  Uploader({super.key, this.file, this.description, this.tags});

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask? _uploadTask;

  void _startUpload() async {
    String filepath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filepath).putFile(widget.file!);
    });

    MyUser? user = await MyUser.getCurrentUser();
    final newImage = MyImage(path: filepath, userName: user!.getName, description: widget.description ?? "", tags: widget.tags ?? const ['foryou']);
    newImage.createImage();
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
        onPressed: _startUpload,
        icon: const Icon(Icons.cloud_upload_outlined), 
        label: const Text('Upload')
      );
    }
  }
}
