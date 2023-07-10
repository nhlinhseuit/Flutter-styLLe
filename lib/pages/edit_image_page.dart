import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stylle/constants/routes.dart';

import '../services/collections/my_images.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({super.key});

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  late final TextEditingController _imageDescriptionController;
  late final TextEditingController _imageTagsController;
  String _imageDescriptionText = '';
  String? _imageTagsText = '';

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
      _imageTagsText = _imageTagsController.text.isEmpty
          ? null
          : _imageTagsController.text.trim();
    });
  }

  void updateImage(MyImage image) {
    image.description = _imageDescriptionText.isEmpty
        ? image.description
        : _imageDescriptionText;
    image.tags = _imageTagsText == null || _imageTagsText!.isEmpty
        ? image.tags
        : _imageTagsText!.split(',').map((tag) => tag.trim()).toList();
    image.update();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as MyImage;
    final imageUrl = args.imagePath;
    _updateWidgetText();

    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 20),
        child: FloatingActionButton.small(
          elevation: 1,
          backgroundColor: Colors.black.withOpacity(.4),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: ListView(children: [
        SizedBox(
          width: double.infinity,
          // height: 610,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(38),
                bottomRight: Radius.circular(38)),
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _imageDescriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF303030),
                    border: const OutlineInputBorder(),
                    hintText: args.description == "" ? 'Description (optional)' : args.description,
                    hintStyle: const TextStyle(color: Colors.white60)),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _imageTagsController,
                  enabled: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF303030),
                      border: const OutlineInputBorder(),
                      hintText: args.tags.isNotEmpty ? args.tags.join(", ") : 'pets, fashion (optional)',
                      hintStyle: const TextStyle(color: Colors.white60)),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    updateImage(args);
                    Navigator.of(context)
                        .popAndPushNamed(detailPageRout, arguments: args);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Save')),
            ],
          ),
        )
      ]),
    );
  }
}
