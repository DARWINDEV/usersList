import 'package:login/src/models/model.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class Operation{
  static Future<Database> _openDB() async{
    return openDatabase(
      join(await getDatabasesPath(), 'form.db'),
      onCreate: (db, version) => db.execute("CREATE TABLE form (id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, borndate TEXT, address TEXT )"), version: 1
    );
  }

  static Future<void> insert(Model form)async{
    Database database = await _openDB();

    return database.insert("form", form.toMap());
  }

  static Future<void> update(Model form)async{
    Database database = await _openDB();

    return database.update("form", form.toMap() , where: 'id = ?', whereArgs: [form.id]);
  }

  static Future<void> delete(Model form)async{
    Database database = await _openDB();

    return database.delete("form", where: 'id = ?', whereArgs: [form.id]);
  }


  static Future<List<Model>> users() async{
    Database database = await _openDB();

    final List<Map<String, dynamic>>usersMap = await database.query("form");

    for (var user in usersMap) {
      print("-----" + user['firstname']);
      print("-----" + user['lastname']);
      print("-----" + user['borndate']);
      print("-----" + user['address']);
      print('++++++++++++++++++++++++');
    }
    
    return List.generate(usersMap.length, (index) => Model(
      id: usersMap[index]['id'],
      firstName: usersMap[index]['firstname'],
      lastName: usersMap[index]['lastname'],
      bornDate: usersMap[index]['borndate'],
      address: usersMap[index]['address']
    ));
  }

}

 