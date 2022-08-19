import 'package:tasktodo/db.dart';

abstract class GetTask {
  late Conection conection;
  getData ()async{
    // var res =  await conection!.list();
//    print(res[0].titulo);
//    print(res[1].titulo);
//    print(res[2].titulo);
//    print(res[3].titulo);
   return await conection!.list();
  }
}