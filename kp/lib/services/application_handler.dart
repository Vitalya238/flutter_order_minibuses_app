import 'package:kp/models/Application.dart';
import 'package:sqflite/sqflite.dart';

const String applicationTableName = 'DriverApplication';
const String columnID = 'APPLICATIONID';
const String columnExperience = 'EXPERIENCE';
const String columnLicensePhoto = 'LICENSE_PHOTO';
const String columnUserId = 'USERID';

class DriverApplicationHandler {
  late Database db;

  DriverApplicationHandler(this.db);

  Future<void> createTable() async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $applicationTableName (
          $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnExperience INTEGER NOT NULL,
          $columnLicensePhoto BLOB NOT NULL,
          $columnUserId INTEGER NOT NULL)
      ''');
  }

  Future<int> insert(DriverApplication application) async {
    return await db.insert(applicationTableName, application.toMap());
  }

  Future<DriverApplication?> getApplication(int id) async {
    List<Map> maps = await db.query(
      applicationTableName,
      columns: [
        columnID,
        columnExperience,
        columnLicensePhoto,
        columnUserId
      ],
      where: '$columnID = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return DriverApplication.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(
      applicationTableName,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(DriverApplication application) async {
    return await db.update(
      applicationTableName,
      application.toMap(),
      where: '$columnID = ?',
      whereArgs: [application.id],
    );
  }

  Future<List<DriverApplication>> getAllApplications() async {
    List<Map<String, dynamic>> maps = await db.query(applicationTableName);
    List<DriverApplication> applications = [];
    for (var map in maps) {
      applications.add(DriverApplication.fromMap(map));
    }
    return applications;
  }

  Future<void> close() async => db.close();
}