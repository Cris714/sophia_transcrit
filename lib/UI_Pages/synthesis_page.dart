import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_transcrit2/UI_Pages/documents_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Managers/app_provider.dart';
import '../Managers/requests_manager.dart';
import '../Notification/notification_service.dart';

class SynthesisPage extends StatefulWidget {
  final String folder;
  final List<String> pathList;
  const SynthesisPage({super.key, required this.folder, required this.pathList});

  @override
  State<SynthesisPage> createState() => _SynthesisPage();
}

class _SynthesisPage extends State<SynthesisPage> {

  late String folder;
  late List<String> pathList;
  late int counter;
  late AppProvider _appProvider;
  late final NotificationService notificationService;
  //final ReceivePort _port = ReceivePort();
  late TextEditingController myController;
  late TextEditingController nameController;
  late TextEditingController modifyController;

  Future<void> computeFuture = Future.value();
  List<String> reqList = [];
  String documentFolder = "documents";
  bool keySelected = false;
  bool sumSelected = true;
  int countError = 0;

  @override
  void initState() {
    getSharedPref();
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();

    super.initState();
    folder = widget
        .folder;
    pathList = widget
        .pathList;
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    myController = TextEditingController();
    nameController = TextEditingController();

    reqList = ['Dame las palabras clave del texto','Dame el resumen del texto.'];
  }

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        _appProvider.setScreen(const DocumentsPage(), 2);
      });

  void getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0);
      nameController.text = 'document$counter';
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final c = (prefs.getInt('counter') ?? 0)+1;
    counter = c;
    prefs.setInt('counter', counter);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  ]
              ),
              const Center(
                child: Text(
                    "What's next?",
                    style: TextStyle(fontSize: 30)
                ),
              ),
              const Center(
                child: Text(
                    'Generate your document.',
                    style: TextStyle(fontSize: 17)
                ),
              ),
              const SizedBox(height: 50),
              FloatingActionButton.extended(
                onPressed: () async {
                  final req = await openDialog();
                  if (req == null || req.isEmpty) return;
                  setState(() { reqList.add(req); });
                },
                label: const Text('New request'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3 - 11,
                  //color: primary[100],
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: reqList.length,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(top: 5),
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                              onTap: () async {
                                modifyController = TextEditingController(text: reqList[index]);
                                final req = await modifyDialog();
                                if (req == null || req.isEmpty) return;
                                setState(() { reqList[index] = req; });
                              },
                              title: Text(reqList[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.highlight_remove),
                                onPressed: () => setState(() { reqList.removeAt(index); }),
                              ),
                            )
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                  obscureText: false,
                  autofocus: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Document Name',
                  ),
                  controller: nameController
              ),
              const SizedBox(height: 30, width: 10),
              reqList.isNotEmpty ?
              ElevatedButton(
                onPressed: () {
                  if(reqList.isNotEmpty && nameController.text != ""){
                    () async {
                      for (var file in pathList) {
                        await sendText('$folder/$file');
                      }
                      getProcessedContent(pathList, reqList, nameController.text);
                    }();
                    Navigator.pop(context);
                    _appProvider.setScreen(const DocumentsPage(), 2);
                    _appProvider.setShowCardDocs(true);
                  }
                },
                child: const Text('Generate document')
              )
                  : const ElevatedButton(onPressed: null, child: Text('Make a request'))
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('New Request'),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter a new request'
        ),
        controller: myController
      ),
      actions: [
        TextButton(
          onPressed: () {Navigator.of(context).pop();},
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: submitRequest,
          child: const Text('SUBMIT'),
        )
      ]
    ),
  );

  Future<String?> modifyDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
        title: const Text('Modify Request'),
        content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Enter your request'
            ),
            controller: modifyController
        ),
        actions: [
          TextButton(
            onPressed: () {Navigator.of(context).pop();},
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: modifyRequest,
            child: const Text('SUBMIT'),
          )
        ]
    ),
  );

  void modifyRequest(){
    Navigator.of(context).pop(modifyController.text);
    modifyController.clear();
  }

    void submitRequest(){
      Navigator.of(context).pop(myController.text);
      myController.clear();
    }

    /*void _startBackgroundTask() async {
      await Isolate.spawn(_backgroundTask, [_port.sendPort, folder, pathList, reqList]);
      _port.listen((message) {
        // Handle background task completion
        var msg = "";
        if(message[1] == 200){
          msg = "Your document is ready!";
          writeDocument('documents', nameController.text, message[0]);
          _appProvider.getDocuments();
          // Save an integer value to 'counter' key.
          _incrementCounter();
        } else {
          countError = countError + 1;
          _appProvider.addDocsError(ErrorItem("${nameController.text}.txt", message[1]));
          msg = "$countError error found processing your document.";
        }

        notificationService.showLocalNotification(
            id: 0,
            title: msg,
            body: "Tap to continue.",
            payload: ""
        );
        if(countError != 0){
          _appProvider.setShowDocsErrors(true);
        }
        countError = 0;
      });
      notificationService.showLocalNotification(
          id: 0,
          title: "Text processing in progress...",
          body: "",
          payload: ""
      );
    }

    static void _backgroundTask(List<dynamic> args) {
      SendPort sendPort = args[0];
      String folder = args[1];
      List<String> pathList = args[2];
      List<String> reqList = args[3];

      () async {
        try {
          for (var file in pathList) {
            await sendText('$folder/$file');
          }
          var response = await getProcessedContent(pathList, reqList);
          var content = response.body;

          sendPort.send([content, response.statusCode]);
        }
        catch (e) {
          sendPort.send(["Error", 0]);
        }
      }();
    }*/
  }