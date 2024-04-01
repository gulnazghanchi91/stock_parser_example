import 'package:flutter/material.dart';

showDialogFlash(context, errorMessage) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        );
      });
}

Color getStockTagColor(String value) {
    switch (value) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
    }
    return Colors.black;
  }
