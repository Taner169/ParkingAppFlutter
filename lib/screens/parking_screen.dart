import 'package:flutter/material.dart';
import '../models/parking.dart';
import '../models/vehicle.dart';
import '../models/parking_space.dart';
import '../services/api_service.dart';

class ParkingScreen extends StatefulWidget {
  final String username;

  const ParkingScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final apiService = ApiService(); // ✅ Detta behövdes!

  List<Parking> parkings = [];
  List<Vehicle> vehicles = [];
  List<ParkingSpace> spaces = [];

  String? selectedVehicle;
  String? selectedSpace;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final allParkings = await apiService.getParkings();
      final allVehicles = await apiService.getVehicles();
      final allSpaces = await apiService.getParkingSpaces();

      setState(() {
        parkings = allParkings;
        vehicles =
            allVehicles.where((v) => v.owner == widget.username).toList();
        spaces = allSpaces;
      });
    } catch (e) {
      print("Fel vid laddning: $e");
    }
  }

  Future<void> startParking() async {
    if (selectedVehicle != null && selectedSpace != null) {
      final parking = Parking(
        vehicle: selectedVehicle!,
        space: selectedSpace!,
        startTime: DateTime.now().toIso8601String(),
        owner: widget.username,
      );

      try {
        await apiService.addParking(parking);
        await loadData();
      } catch (e) {
        print("Fel vid start av parkering: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parkering")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: startParking,
            child: Text("Starta parkering"),
          ),
          Expanded(
            child: ListView(
              children: parkings
                  .map((p) => ListTile(
                        title: Text("${p.vehicle} → ${p.space}"),
                        subtitle: Text("Start: ${p.startTime}"),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
