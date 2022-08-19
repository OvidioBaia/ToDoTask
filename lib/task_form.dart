
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tasktodo/db.dart';
import 'package:tasktodo/task_model.dart';

class NewTask extends StatefulWidget {
  var id;
  var func;
  NewTask({ this.id,  this.func }) ;

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  var id;
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _duracaoController = TextEditingController();
  TextEditingController _dataController = TextEditingController();
  GlobalKey<FormState> _formulario = GlobalKey<FormState>();
  Conection? conection ;

  var formatoDataNascimento =  MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });
  loadForEdit() async {
    print(widget.id);
    var teste = widget.id != null ?  true : false;
    if(teste) {
      List<Task> task = <Task>[];
      task = await conection!.getById(widget.id);
      setState(()  {

        _tituloController.text = task[0].titulo;
        _descricaoController.text = task[0].descricao;
        _duracaoController.text = task[0].duracao;
        _dataController.text = task[0].data;

      });
    }
  }
var f;
  @override
  void initState() {
    conection =Conection();
    loadForEdit();
    id = widget.id;
    f = widget.func;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CADASTRO", style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor:  Color.fromRGBO(70, 168, 177, 1),
        ),
        body: SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container( height: 70.0,
                  //margin: EdgeInsets.only(top: 10.0) ,
                  padding: EdgeInsets.only(top: 15.0),
                  color: Color.fromRGBO(70, 168, 177, 1),
                  child: Text("Atividade",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        //backgroundColor: Color.fromRGBO(70, 168, 177, 1),
                        fontSize: 30.0
                    ),
                  ),
                ),
                Form(key: _formulario,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                        child:TextFormField(
                          // key: _formulario,
                            controller:  _tituloController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //icon: Icon(Icons.person),
                                hintText: "Estudar banco de dados",
                                labelText: 'Titulo',
                                labelStyle: TextStyle(color: Colors.blue,fontSize: 25.0)
                            ),
                            // ignore: missing_return
                            validator:(value) {
                              if(value!.isEmpty){
                                return "CAMPO OBRIGATÓRIO";
                              }
                            }
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                        child:TextFormField(
                            controller:  _descricaoController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //icon: Icon(Icons.person),
                                hintText: "Descricão",
                                labelText: 'Descricão',
                                labelStyle: TextStyle(color: Colors.blue,fontSize: 25.0)
                            ),
                            // ignore: missing_return
                            validator:(value){
                              if(value!.isEmpty){
                                return "CAMPO OBRIGATÓRIO";
                              }
                            }
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                        child:TextFormField(
                            controller: _dataController,
                            inputFormatters: [formatoDataNascimento],
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              // icon: Icon(Icons.date_range),
                                hintText: '01/05/2020?',
                                labelText: 'Data da atividade',
                                labelStyle: TextStyle(color: Colors.blue,fontSize: 25.0)
                            ),
                            // ignore: missing_return
                            validator:(value){
                              if(value!.isEmpty){
                                return "CAMPO OBRIGATÓRIO";
                              }
                            }
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                        child:TextFormField(
                            controller: _duracaoController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              // icon: Icon(Icons.settings_cell),
                                hintText: 'Em minutos',
                                labelText: 'Duração da atividade(em mminutos)',
                                labelStyle: TextStyle(color: Colors.blue, fontSize: 25.0)
                            ),
                            // ignore: missing_return
                            validator:(value){
                              if(value!.isEmpty){
                                return "CAMPO OBRIGATÓRIO";
                              }
                            }
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                          child: Container(height: 45.0,
                            child: RaisedButton(
                              child: widget.id != null ?
                                Text("ATUALIZAR",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,color: Colors.white),)
                                :
                              Text("Salvar",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,color: Colors.white),),
                              textColor: Colors.white,
                              color:Color.fromRGBO(70, 168, 177, 1),
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              onPressed: ()async{
                                if(_formulario.currentState!.validate()){
                                  print(widget.id);
                                  int ids =widget.id;
                                  widget.id != null ?

                                  conection!.updateQuantity(
                                      Task(
                                          id: widget.id,
                                          titulo: _tituloController.text,
                                          descricao: _descricaoController.text,
                                          duracao: _duracaoController.text,
                                          data: _dataController.text
                                      )
                                  ).then((value){
                                    print('atualizado');
                                  }).onError((error, stackTrace) {
                                    print("error"+error.toString());
                                  })
                                  :
                                  conection!.insert(
                                      Task(
                                          titulo: _tituloController.text,
                                          descricao: _descricaoController.text,
                                          duracao: _duracaoController.text,
                                          data: _dataController.text
                                      )
                                  ).then((value){
                                    print('adicionado');
                                    _tituloController.text = '';
                                    _descricaoController.text = '';
                                    _duracaoController.text = '';
                                    _dataController.text = '';
                                  }).onError((error, stackTrace) {
                                    print("error"+error.toString());
                                  });
                                }
                              },
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );

  }
}

