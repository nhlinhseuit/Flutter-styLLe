import 'package:flutter/material.dart';

class ImageManagementPage extends StatefulWidget {
  const ImageManagementPage({super.key});

  @override
  State<ImageManagementPage> createState() => _ImageManagementPageState();
}

class _ImageManagementPageState extends State<ImageManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const ListTile(
                
              );
            }),
      ),
    );
  }
}
