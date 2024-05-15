class Order {
  final String columnOrderID = 'ORDERID';
  final String columnTripID = 'TRIPID';
  final String columnClientID = 'CLIENTID';
  final String columnPassengersQuantity = 'PASSENGERSQUANTITY';

  int orderID = 0;
  late int tripId;
  late int clientId;
  late int passengersQuantity;

  Order(
      this.tripId,
      this.clientId,
      this.passengersQuantity,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTripID: tripId,
      columnClientID: clientId,
      columnPassengersQuantity: passengersQuantity
    };
    return map;
  }

  Order.fromMap(Map<dynamic, dynamic> map) {
    orderID = map[columnOrderID] ?? 0;
    tripId = map[columnTripID];
    clientId = map[columnClientID];
    passengersQuantity = map[columnPassengersQuantity];
  }

}