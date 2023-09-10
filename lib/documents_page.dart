import 'package:flutter/material.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPage();
}

class _DocumentsPage extends State<DocumentsPage> {
  Future<void> computeFuture = Future.value();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              children: [
                IconButton(
                    onPressed: null,
                    icon: Icon(Icons.logout, size: 35)
                ),
                SizedBox(width: 20),
                Center(
                  child: Text(
                      "My Documents",
                      style: TextStyle(fontSize: 20)
                  ),
                ),
              ]
          ),
          Divider()
        ],
      ),
    );
  }
}
