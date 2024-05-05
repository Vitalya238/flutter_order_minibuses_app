
import 'package:kp/models/model.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = 'ROUTE';
const String columnTicketId = 'TICKETID';
const String columnTripId = 'TRIPID';
const String columnUserId = 'USERID';
const String columnLandingFromId = 'LANDING_FROM_ID';
const String columnLandingToId = 'LANDING_TO_ID';
const String columnCountPlaces = 'COUNT_PLACES';
const String columnCost = 'COST';



class TicketHandler{
  late Database db;
  TicketHandler(this.db);
  Future createTable() async{
    await db.execute('''
        create table IF NOT EXISTS $tableName ($columnTicketId INTEGER PRIMARY KEY autoincrement,
                                $columnTripId INTEGER not null,
                                $columnUserId INTEGER not null,
                                $columnLandingFromId INTEGER not null,
                                $columnLandingToId INTEGER not null,
                                $columnCountPlaces INTEGER not null,
                                $columnCost Real not null,
                                FOREIGN KEY ($columnUserId) REFERENCES CLIENT(USERID),
                                FOREIGN KEY ($columnTripId) REFERENCES TRIP(TRIPID),
                                FOREIGN KEY ($columnLandingFromId) REFERENCES BUSSTOP(BUS_STOP_ID),
                                FOREIGN KEY ($columnLandingToId) REFERENCES BUSSTOP(BUS_STOP_ID))
      ''');

  }
  Future<int> insert(Ticket ticket) async{
    return await db.insert(tableName, ticket.toMap());
  }
  Future<Ticket?> getTicket(int id) async{
    List<Map> maps = await db.query(tableName,
        columns: [columnTicketId, columnTripId, columnUserId, columnLandingFromId,columnLandingToId,columnCountPlaces,columnCost],
        where: '$columnTicketId = ?',
        whereArgs: [id]);
    if(maps.isNotEmpty){
      return Ticket.fromMap(maps.first);
    }
    return null;
  }
  Future<int> delete(int id) async{
    return await db.delete(tableName, where: '$columnTicketId = ?', whereArgs: [id]);
  }
  Future<int> update(Ticket ticket) async{
    return await db.update(tableName, ticket.toMap(), where: '$columnTicketId = ?', whereArgs: [ticket.id]);
  }
  Future<List<Ticket>> getAllTickets() async{
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Ticket> tickets = [];
    for(var map in maps){
      tickets.add(Ticket.fromMap(map));
    }
    return tickets;
  }

  Future close() async => db.close();
}