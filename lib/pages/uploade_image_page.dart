import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  State<ImageCapture> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  File? _imageFile;
  bool _showFabMenu = false;


  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await _picker.pickImage(source: source);

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
    return Scaffold(
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile!),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _cropImage,
                  child: const Icon(Icons.crop),
                ),
                ElevatedButton(
                  onPressed: _clear,
                  child: const Icon(Icons.refresh),
                )
              ],
            ),

          ]
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 360),
            child: _showFabMenu
                ? Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: 'camera',
                        onPressed: () => _pickImage(ImageSource.camera),
                        tooltip: 'Camera',
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        heroTag: 'gallery',
                        onPressed: () => _pickImage(ImageSource.gallery),
                        tooltip: 'Gallery',
                        child: const Icon(Icons.image_search),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _showFabMenu = !_showFabMenu;
              });
            },
            tooltip: 'Show menu',
            child: Icon(_showFabMenu ? Icons.close : Icons.publish),
          ),

          if (_imageFile != null)
            Uploader(file: _imageFile),
        ]
      ),
      
    );
  }
}

class Uploader extends StatefulWidget {
  final File? file;
  const Uploader({super.key, this.file});

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask? _uploadTask;

  void _startUpload() {
    String filepath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filepath).putFile(widget.file!);
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
              if (event?.state == TaskState.success) 
                const Text('Congrats'),
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