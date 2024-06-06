import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var jobs = [];
  final inputController = TextEditingController();
  int idx = -1;
  bool isEdit = false;
  Widget onlySubmitBtn (String text) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(text),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void addJob() {
    if (!isEdit) {
      if (inputController.text.trim().isNotEmpty) {
        setState(() {
          jobs.insert(0, inputController.text.trim());
          inputController.clear();
        });
      }
    } else {
      submitEditJob();
    }
  }

  void deleteJob(int index) {
    Widget okBtn = TextButton(
        onPressed: () {
          if (index != -1) {
            setState(() {
              jobs.removeAt(index);
            });
            Navigator.of(context).pop();
          }
        },
        child: const Text('Submit'));
    AlertDialog alert = AlertDialog(
      title: const Text('Warning'),
      content: Text('Delete ${jobs[index]} ?'),
      actions: <Widget>[okBtn, onlySubmitBtn('Cancel')],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void editJob(int index) {
    setState(() {
      idx = index;
      inputController.text = jobs[index];
      isEdit = true;
    });
  }

  void submitEditJob() {
    setState(() {
      jobs.replaceRange(idx, idx + 1, [inputController.text.trim()]);
      idx = -1;
      isEdit = false;
      inputController.clear();
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Change successfully'),
            actions: <Widget>[onlySubmitBtn('OK')],
          );
        });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: TextField(
                controller: inputController,
                maxLength: 30,
                autofocus: false,
              ),
            ),
            TextButton(
                onPressed: addJob,
                style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0)),
                child: Text(isEdit ? 'Edit' : 'Add')),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: ListView.builder(
                      itemCount: jobs.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(jobs[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    )),
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    TextButton(
                                        onPressed: () => editJob(index),
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.grey[200],
                                        )),
                                    const SizedBox(width: 5),
                                    TextButton(
                                        onPressed: () => deleteJob(index),
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey[200],
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
