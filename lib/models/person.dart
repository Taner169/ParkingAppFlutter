class Person {
  final String name; // ska vara non-nullable
  final String personalNumber; // ska vara non-nullable

  Person({required this.name, required this.personalNumber});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      personalNumber: json['personalNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'personalNumber': personalNumber,
    };
  }
}
