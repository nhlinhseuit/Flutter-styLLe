
import 'package:flutter/material.dart';

Future<void> showMessageDialog(BuildContext context, String message, {String title = 'Hi there'}) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text(title),
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