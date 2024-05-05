import 'dart:typed_data';

class Bus {
  final String columnBusID = 'BUSID';
  final String columnBusBrand = 'BUSBRAND';
  final String columnBusNumber = 'BUSNUMBER';
  final String columnCountPlaces = 'COUNT_PLACES';
  final String columnBusImage = 'BUSIMAGE';

  int id = 0;
  late String busBrand;
  late String busNumber;
  late int countPlaces;
  late Uint8List busImage;

  Bus(
      this.busBrand,
      this.busNumber,
      this.countPlaces,
      this.busImage,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnBusBrand: busBrand,
      columnBusNumber: busNumber,
      columnCountPlaces: countPlaces,
      columnBusImage: busImage,
    };
    return map;
  }

  Bus.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnBusID];
    busBrand = map[columnBusBrand];
    busNumber = map[columnBusNumber];
    countPlaces = map[columnCountPlaces];
    busImage = map[columnBusImage];
  }
}