import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onConfirm;

  const DeleteConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Icon(
        Icons.delete_rounded,
        size: 48.0, // Set the width (and height) of the icon
        color: Colors.red,
      ),
      content: const Center(
          heightFactor: 0.4,
          child: Text(
            'Are you sure to delete this?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2.0), // Border radius
                ),
                padding: const EdgeInsets.all(4.0),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                onConfirm(); // Llama a la función de confirmación
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2.0), // Border radius
                ),
                padding: const EdgeInsets.all(4.0),
                child: const Text(
                    'Delete',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
