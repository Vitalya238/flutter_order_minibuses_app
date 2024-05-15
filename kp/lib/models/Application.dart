import 'dart:typed_data';

class DriverApplication {
  final String columnID = 'APPLICATIONID';
  final String columnExperience = 'EXPERIENCE';
  final String columnLicensePhoto = 'LICENSE_PHOTO';
  final String columnUserId = 'USERID';


  int id = 0;
  late int experience;
  late Uint8List license;
  late int userId;

  DriverApplication(
      this.experience,
      this.license,
      this.userId,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnExperience: experience,
      columnLicensePhoto: license,
      columnUserId: userId,
    };
    if (id != 0) {
      map[columnID] = id;
    }
    return map;
  }

  DriverApplication.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnID] ?? 0;
    experience = map[columnExperience];
    license = map[columnLicensePhoto];
    userId = map[columnUserId];
  }
}
