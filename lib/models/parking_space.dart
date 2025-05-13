class ParkingSpace {
  final String id;
  final String address;
  final double pricePerHour;

  ParkingSpace({
    required this.id,
    required this.address,
    required this.pricePerHour,
  });

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'].toString(),
      address: json['address'],
      pricePerHour: double.parse(json['pricePerHour'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'pricePerHour': pricePerHour,
    };
  }
}
