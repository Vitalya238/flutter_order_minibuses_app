class Order {
  final String columnOrderID = 'ORDERID';
  final String columnTripID = 'TRIPID';
  final String columnClientID = 'CLIENTID';

  int orderID = 0;
  late int tripId;
  late int clientId;

  Order(
      this.tripId,
      this.clientId,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTripID: tripId,
      columnClientID: clientId
    };
    return map;
  }

  Order.fromMap(Map<dynamic, dynamic> map) {
    orderID = map[columnOrderID] ?? 0;
    tripId = map[columnTripID];
    clientId = map[columnClientID];
  }

}