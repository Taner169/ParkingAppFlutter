import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';
import '../models/vehicle.dart';
import '../models/parking.dart';
import '../models/parking_space.dart';

class ApiService {
  final String baseUrl = 'http://192.168.50.129:8080/api';

  // 👤 PERSONER
  Future<List<Person>> getPersons() async {
    final response = await http.get(Uri.parse('$baseUrl/persons'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Person.fromJson(e)).toList();
    } else {
      throw Exception("Misslyckades att hämta personer");
    }
  }

  Future<void> addPerson(Person person) async {
    final response = await http.post(
      Uri.parse('$baseUrl/persons'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(person.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att lägga till person");
    }
  }

  Future<void> deletePerson(String personalNumber) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/persons/$personalNumber'));
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att ta bort person");
    }
  }

  Future<void> updatePerson(String personalNumber, Person updated) async {
    final response = await http.put(
      Uri.parse('$baseUrl/persons/$personalNumber'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updated.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att uppdatera person");
    }
  }

  // 🚘 FORDON
  Future<List<Vehicle>> getVehicles() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicles'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Vehicle.fromJson(e)).toList();
    } else {
      throw Exception("Misslyckades att hämta fordon");
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att lägga till fordon");
    }
  }

  Future<void> deleteVehicle(String regNumber) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/vehicles/$regNumber'));
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att ta bort fordon");
    }
  }

  Future<void> updateVehicle(String regNumber, Vehicle updated) async {
    final response = await http.put(
      Uri.parse('$baseUrl/vehicles/$regNumber'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updated.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att uppdatera fordon");
    }
  }

  // 🅿️ PARKERINGAR
  Future<List<Parking>> getParkings() async {
    final response = await http.get(Uri.parse('$baseUrl/parkings'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Parking.fromJson(e)).toList();
    } else {
      throw Exception("Misslyckades att hämta parkeringar");
    }
  }

  Future<void> addParking(Parking parking) async {
    final response = await http.post(
      Uri.parse('$baseUrl/parkings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parking.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att starta parkering");
    }
  }

  Future<void> endParking(Parking p) async {
    final response = await http.put(
      Uri.parse('$baseUrl/parkings/${p.vehicle}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att avsluta parkering");
    }
  }

  Future<void> updateParking(Parking parking) async {
    final response = await http.put(
      Uri.parse('$baseUrl/parkings/${parking.vehicle}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'endTime': parking.endTime}),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att avsluta parkering");
    }
  }

  // 📍 PARKERINGSPLATSER
  Future<List<ParkingSpace>> getParkingSpaces() async {
    final response = await http.get(Uri.parse('$baseUrl/parkingspaces'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => ParkingSpace.fromJson(e)).toList();
    } else {
      throw Exception("Misslyckades att hämta platser");
    }
  }

  Future<void> addParkingSpace(ParkingSpace space) async {
    final response = await http.post(
      Uri.parse('$baseUrl/parkingspaces'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(space.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att lägga till plats");
    }
  }

  Future<void> updateParkingSpace(String id, ParkingSpace updated) async {
    final response = await http.put(
      Uri.parse('$baseUrl/parkingspaces/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updated.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Misslyckades att uppdatera parkeringsplats");
    }
  }

  Future<void> deleteParkingSpace(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/parkingspaces/$id'));
    if (response.statusCode != 200) {
      throw Exception("Misslyckades att ta bort parkeringsplats");
    }
  }
}
