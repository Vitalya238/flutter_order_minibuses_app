import 'package:kp/models/City.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = 'CITY';
const String columnCityID = 'CITYID';
const String columnCityName = 'CITYNAME';



class CityHandler{
  late Database db;

  CityHandler(this.db);

  Future createTable() async{
    await db.execute('''
        create table IF NOT EXISTS $tableName ($columnCityID INTEGER PRIMARY KEY autoincrement,
                                $columnCityName TEXT not null)
      ''');

  }
  Future<int> insert(City city) async{
    return await db.insert(tableName, city.toMap());
  }
  Future<City?> getCity(int id) async{
    List<Map> maps = await db.query(tableName,
        columns: [columnCityID, columnCityName],
        where: '$columnCityID = ?',
        whereArgs: [id]);
    if(maps.isNotEmpty){
      return City.fromMap(maps.first);
    }
    return null;
  }
  Future<int> delete(int id) async{
    return await db.delete(tableName, where: '$columnCityID = ?', whereArgs: [id]);
  }
  Future<int> update(City city) async{
    return await db.update(tableName, city.toMap(), where: '$columnCityID = ?', whereArgs: [city.cityId]);
  }
  Future<List<City>> getAllCities() async {

    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<City> cities = [];
    for(var map in maps){
      cities.add(City.fromMap(map));
    }
    return cities;
  }
  Future<bool> checkIfCityExists(String cityName) async {
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: '$columnCityName = ?',
      whereArgs: [cityName],
    );
    return result.isNotEmpty;
  }


  Future close() async => db.close();
}