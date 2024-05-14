import 'package:sqflite/sqflite.dart';
import 'package:kp/models/Client.dart';

const String tableName = 'CLIENT';
const String columnUserId = 'USERID';
const String columnUserEmail = 'USEREMAIL';
const String columnUserPassword = 'USERPASSWORD';
const String columnUsername = 'USERNAME';
const String columnUserLastname = 'USERLASTNAME';
const String columnTelephone = 'TELEPHONE';
const String columnRoleId = 'USERROLEID';
const String columnStatus = 'USERSTATUS';



class ClientHandler {
  late Database db;

  ClientHandler(this.db);

  Future createTable() async{
    await db.execute('''
        create table IF NOT EXISTS $tableName ($columnUserId INTEGER PRIMARY KEY autoincrement,
                                $columnUserEmail TEXT not null,
                                $columnUserPassword TEXT NOT NULL,
                                $columnUsername TEXT,
                                $columnUserLastname TEXT,
                                $columnTelephone TEXT,
                                $columnRoleId INTEGER,
                                $columnStatus TEXT CHECK($columnStatus IN ('REGISTERED', 'UNREGISTERED')), 
                                FOREIGN KEY ($columnRoleId) REFERENCES ROLE(ROLEID))
      ''');
    await insertDefaultClient();
  }
  Future<int> insert(Client client) async{
    return await db.insert(tableName, client.toMap());
  }
  Future<void> insertDefaultClient() async {
    Client defaultClient = Client(
      "admin@admin.com",
      "admin",
      "admin",
      "admin",
      "1111",
      1,
      "REGISTERED",
    );


    Client vodila = Client(
      "driver@driver.com",
      "driver",
      "driver",
      "driver",
      "3333",
      3,
      "REGISTERED",
    );
    await db.insert(tableName, defaultClient.toMap());
    await db.insert(tableName, vodila.toMap());
  }

  Future<Client?> getClient(int id) async{
    List<Map> maps = await db.query(tableName,
        columns: [columnUserId, columnUserEmail, columnUserPassword, columnUsername, columnUserLastname, columnTelephone, columnRoleId, columnStatus],
        where: '$columnUserId = ?',
        whereArgs: [id]);
    if(maps.isNotEmpty){
      return Client.fromMap(maps.first);
    }
    return null;
  }
  Future<int> delete(int id) async{
    return await db.delete(tableName, where: '$columnUserId = ?', whereArgs: [id]);
  }
  Future<int> update(Client client) async{
    return await db.update(tableName, client.toMap(), where: '$columnUserId = ?', whereArgs: [client.userId]);
  }
  Future<List<Client>> getAllClients() async{
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Client> clients = [];
    for(var map in maps){
      clients.add(Client.fromMap(map));
    }
    return clients;
  }



  Future close() async => db.close();
}