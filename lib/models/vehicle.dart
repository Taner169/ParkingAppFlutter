class Vehicle {
  final String registrationNumber;
  final String type;
  final String owner;

  Vehicle({
    required this.registrationNumber,
    required this.type,
    required this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      registrationNumber: json['registrationNumber'] ?? '',
      type: json['type'] ?? '',
      owner: json['owner'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'registrationNumber': registrationNumber,
        'type': type,
        'owner': owner,
      };
}
