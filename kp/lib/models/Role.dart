class Role {
  final String columnRoleID = 'ROLEID';
  final String columnRoleName = 'ROLENAME';

  int id = 0;
  late String roleName;

  Role(this.roleName);

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnRoleName: roleName,
    };
    return map;
  }

  Role.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnRoleID];
    roleName = map[columnRoleName];
  }
}