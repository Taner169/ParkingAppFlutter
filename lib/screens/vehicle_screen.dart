import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';

class VehicleScreen extends StatefulWidget {
  final String username;

  const VehicleScreen({super.key, required this.username});

  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final apiService = ApiService();

  List<Vehicle> vehicles = [];
  TextEditingController regNrController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    try {
      final allVehicles = await apiService.getVehicles();
      setState(() {
        vehicles =
            allVehicles.where((v) => v.owner == widget.username).toList();
      });
    } catch (e) {
      print("Kunde inte ladda fordon: $e");
    }
  }

  Future<void> addVehicle() async {
    final reg = regNrController.text.trim();
    final type = typeController.text.trim();

    if (reg.isNotEmpty && type.isNotEmpty) {
      final vehicle = Vehicle(
        registrationNumber: reg,
        type: type,
        owner: widget.username,
      );
      try {
        await apiService.addVehicle(vehicle);
        regNrController.clear();
        typeController.clear();
        await loadVehicles();
      } catch (e) {
        print("Fel vid tillägg: $e");
      }
    }
  }

  Future<void> deleteVehicle(String reg) async {
    try {
      await apiService.deleteVehicle(reg);
      await loadVehicles();
    } catch (e) {
      print("Fel vid borttagning: $e");
    }
  }

  Future<void> editVehicle(Vehicle vehicle) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final regController =
            TextEditingController(text: vehicle.registrationNumber);
        final typeController = TextEditingController(text: vehicle.type);

        return AlertDialog(
          title: const Text("Redigera fordon"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: regController,
                decoration:
                    const InputDecoration(labelText: "Registreringsnummer"),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: "Typ"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Avbryt"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, {
                'registrationNumber': regController.text,
                'type': typeController.text,
              }),
              child: const Text("Spara"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      try {
        final updatedVehicle = Vehicle(
          registrationNumber: result['registrationNumber']!,
          type: result['type']!,
          owner: widget.username,
        );
        await apiService.updateVehicle(
            vehicle.registrationNumber, updatedVehicle);
        await loadVehicles();
      } catch (e) {
        print("Fel vid uppdatering: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = searchController.text.isEmpty
        ? vehicles
        : vehicles
            .where((v) =>
                v.registrationNumber
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                v.type
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fordon"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: regNrController,
              decoration:
                  const InputDecoration(labelText: 'Registreringsnummer'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Fordonstyp'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addVehicle,
              child: const Text("➕ Lägg till fordon"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: '🔍 Sök fordon...',
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final vehicle = filtered[index];
                  return ListTile(
                    title:
                        Text('${vehicle.registrationNumber} - ${vehicle.type}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editVehicle(vehicle),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              deleteVehicle(vehicle.registrationNumber),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
