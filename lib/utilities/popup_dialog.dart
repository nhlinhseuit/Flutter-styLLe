
import 'package:flutter/material.dart';

Future<void> showMessageDialog(BuildContext context, String message) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: const Text('Hi there'),
      content: Text(message),
      actions:  [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const Text('OK')),
      ],
    );
  });
}