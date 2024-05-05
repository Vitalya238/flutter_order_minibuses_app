class Client {
  final String columnUserId = 'USERID';
  final String columnUserEmail = 'USEREMAIL';
  final String columnUserPassword = 'USERPASSWORD';
  final String columnUsername = 'USERNAME';
  final String columnUserLastname = 'USERLASTNAME';
  final String columnTelephone = 'TELEPHONE';
  final String columnRoleId = 'USERROLEID';
  final String columnStatus = 'USERSTATUS';

  int userId = 0;
  late String userEmail;
  late String userPassword;
  late String username;
  late String userLastname;
  late String telephone;
  late int roleId;
  late String status;

  Client(
      this.userEmail,
      this.userPassword,
      this.username,
      this.userLastname,
      this.telephone,
      this.roleId,
      this.status,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnUserEmail : userEmail,
      columnUserPassword : userPassword,
      columnUsername : username,
      columnUserLastname : userLastname,
      columnTelephone : telephone,
      columnRoleId : roleId,
      columnStatus : status,
    };
    return map;
  }

  Client.fromMap(Map<dynamic, dynamic> map) {
    userId = map[columnUserId];
    userEmail = map[columnUserEmail];
    userPassword = map[columnUserPassword];
    username = map[columnUsername];
    userLastname = map[columnUserLastname];
    telephone = map[columnTelephone];
    roleId = map[columnRoleId];
    roleId = map[columnRoleId];
    status = map[columnStatus];
  }

  static Client empty() {
    return Client(
      '', // userEmail
      '', // userPassword
      '', // username
      '', // userLastname
      '', // telephone
      0,  // roleId
      '', // status
    );
  }
}