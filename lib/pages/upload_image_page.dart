import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utilities/image_uploader.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  State<ImageCapture> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  late final TextEditingController _imageDescriptionController;
  late final TextEditingController _imageTagsController;
  String _imageDescriptionText = '';
  String _imageTagsText = '';
  File? _imageFile;

  @override
  void initState() {
    _imageDescriptionController = TextEditingController();
    _imageTagsController = TextEditingController();
    _imageDescriptionController.addListener(_updateWidgetText);
    _imageTagsController.addListener(_updateWidgetText);
    super.initState();
  }

  @override
  void dispose() {
    _imageDescriptionController.dispose();
    _imageTagsController.dispose();
    super.dispose();
  }

  void _updateWidgetText() {
    setState(() {
      _imageDescriptionText = _imageDescriptionController.text.trim();
      _imageTagsText = _imageTagsController.text.trim();
    });
  }

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
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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
                Text(
                  "Upload image",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 24.00,
                    )
                  ),
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
      
              Container(
                padding: const EdgeInsets.only(top: 8,),
                child: TextField(
                  controller: _imageDescriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Description (optional)',
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _imageTagsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'jeans, vintage (optional)',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Uploader(
                file: _imageFile, 
                description: _imageDescriptionText,
                tags: _imageTagsText.split(',').map((tag) => tag.trim()).toList(),
              )
            ]
          ]
        )
      ),

      //// FAB VERSION //////

      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: <Widget>[
      //     AnimatedSwitcher(
      //       duration: const Duration(milliseconds: 360),
      //       child: _showFabMenu
      //           ? Column(
      //               // crossAxisAlignment: CrossAxisAlignment.end,
      //               children: <Widget>[
      //                 FloatingActionButton(
      //                   heroTag: 'camera',
      //                   onPressed: () => _pickImage(ImageSource.camera),
      //                   tooltip: 'Camera',
      //                   child: const Icon(Icons.camera_alt_outlined),
      //                 ),
      //                 const SizedBox(height: 16),
      //                 FloatingActionButton(
      //                   heroTag: 'gallery',
      //                   onPressed: () => _pickImage(ImageSource.gallery),
      //                   tooltip: 'Gallery',
      //                   child: const Icon(Icons.image_search),
      //                 ),
      //                 const SizedBox(height: 16),
      //               ],
      //             )
      //           : const SizedBox.shrink(),
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {
      //         setState(() {
      //           _showFabMenu = !_showFabMenu;
      //         });
      //       },
      //       tooltip: 'Show menu',
      //       child: Icon(_showFabMenu ? Icons.close : Icons.publish),
      //     ),
      //     if (_imageFile != null)
      //       Uploader(file: _imageFile),
      //   ]
      // ),
      
    );
  }
}
