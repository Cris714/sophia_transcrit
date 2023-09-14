import 'package:flutter/material.dart';

import 'file_manager_s.dart';


class ViewText extends StatelessWidget {
  final String filename;
  const ViewText({super.key, required this.filename});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, size: 35)
                  ),
                  const SizedBox(width: 20),
                  Center(
                    child: Text(
                        filename,
                        style: const TextStyle(fontSize: 20)
                    ),
                  ),
                ]
            ),
            const Divider(),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: FutureBuilder<String>(
                future: readDocument(filename),
                builder: (context, snapshot) {
                  return Text(
                      snapshot.data ?? "Loading...",
                      style: const TextStyle(fontSize: 17)
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



