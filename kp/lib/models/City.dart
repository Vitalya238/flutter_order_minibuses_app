class City {
  final String columnCityID = 'CITYID';
  final String columnCityName = 'CITYNAME';

  int cityId = 0;
  late String cityName;

  City(
      this.cityName,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnCityName: cityName,
    };
    return map;
  }

  City.fromMap(Map<dynamic, dynamic> map) {
    cityId = map[columnCityID] ?? 0;
    cityName = map[columnCityName];
  }

}