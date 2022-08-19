import 'package:flutter/material.dart';
import 'package:tasktodo/task_form.dart';
import 'package:tasktodo/task_model.dart';

import 'db.dart';
import 'drawer.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ToDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Future<List<Task>> taskList;
  late Future<List<Task>> res;
  Conection? conection ;
  final _pageController = PageController();

  getData ()async{
    var res =  await conection!.list();
    setState(() {
      taskList =  conection!.list();
      print(taskList);
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    conection = Conection() ;
    getData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(icon: Icon(Icons.search), color: Colors.white,onPressed: () async => await getData()),
        ],
      ),
      body: FutureBuilder(
      future: taskList,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: ListTile(title: Text(snapshot.data![index].titulo),
                            subtitle: Text(snapshot.data![index].descricao),
                            trailing: Column(
                              children: [
                                Text(snapshot.data![index].data),
                                Text('${snapshot.data![index].duracao} minutos'),
                              ],
                            )),
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewTask(id: snapshot.data![index].id as int, func: getData)));
                            }
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await conection?.delete(
                                    snapshot.data![index].id as int);
                                await getData();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      drawer: Drawer(
        child: Stack(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(70, 168, 177, 1),
            ),
            ListView(
              padding: EdgeInsets.only(left: 15.0, top: 55.0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 0.0),
                  color: Color.fromRGBO(70, 168, 177, 1),
                  child: Text("MEU APP")
                ),
                GestureDetector(
                    child: ItemMenu(Icons.note_add, "Adicionar Atividade",
                        _pageController, 1),
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewTask()));
                    }
                ),
              ],
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: getData,
//        tooltip: 'Increment',
//        child: const Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
