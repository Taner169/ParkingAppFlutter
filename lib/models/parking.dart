class Parking {
  final String vehicle;
  final String space;
  final String startTime;
  final String owner;
  String? endTime;

  Parking({
    required this.vehicle,
    required this.space,
    required this.startTime,
    required this.owner,
    this.endTime,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      vehicle: json['vehicle'],
      space: json['space'],
      startTime: json['startTime'],
      endTime: json['endTime'] == '' ? null : json['endTime'],
      owner: json['owner'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicle': vehicle,
        'space': space,
        'startTime': startTime,
        'endTime': endTime ?? '',
        'owner': owner,
      };
}
