import 'package:flutter/material.dart';
import '../models/parking_space.dart';
import '../services/api_service.dart';
import '../widgets/snackbar_popup.dart';

class ParkingSpaceScreen extends StatefulWidget {
  const ParkingSpaceScreen({super.key});

  @override
  _ParkingSpaceScreenState createState() => _ParkingSpaceScreenState();
}

class _ParkingSpaceScreenState extends State<ParkingSpaceScreen> {
  final apiService = ApiService();

  final idController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();

  List<ParkingSpace> spaces = [];

  @override
  void initState() {
    super.initState();
    loadSpaces();
  }

  Future<void> loadSpaces() async {
    try {
      final loadedSpaces = await apiService.getParkingSpaces();
      setState(() {
        spaces = loadedSpaces;
      });
    } catch (e) {
      print("Fel vid laddning av parkeringsplatser: $e");
    }
  }

  Future<void> addParkingSpace() async {
    String id = idController.text.trim();
    String address = addressController.text.trim();
    String price = priceController.text.trim();

    if (id.isNotEmpty && address.isNotEmpty && price.isNotEmpty) {
      final space = ParkingSpace(
        id: id,
        address: address,
        pricePerHour: double.tryParse(price) ?? 0.0,
      );

      try {
        await apiService.addParkingSpace(space);
        idController.clear();
        addressController.clear();
        priceController.clear();
        showSnackbar(context, "Parkeringsplats tillagd");
        await loadSpaces();
      } catch (e) {
        print("Fel vid tillägg: $e");
        showSnackbar(context, "Fel vid tillägg");
      }
    }
  }

  Future<void> deleteParkingSpace(String id) async {
    try {
      await apiService.deleteParkingSpace(id);
      showSnackbar(context, "Parkeringsplats borttagen");
      await loadSpaces();
    } catch (e) {
      print("Fel vid borttagning: $e");
      showSnackbar(context, "Fel vid borttagning");
    }
  }

  Future<void> editParkingSpace(ParkingSpace space) async {
    final addressCtrl = TextEditingController(text: space.address);
    final priceCtrl =
        TextEditingController(text: space.pricePerHour.toString());

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Redigera plats"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: "Adress"),
            ),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: "Pris per timme"),
              keyboardType: TextInputType.number,
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
              'address': addressCtrl.text,
              'pricePerHour': priceCtrl.text,
            }),
            child: const Text("Spara"),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        final updated = ParkingSpace(
          id: space.id,
          address: result['address']!,
          pricePerHour: double.tryParse(result['pricePerHour']!) ?? 0.0,
        );
        await apiService.updateParkingSpace(space.id, updated);
        showSnackbar(context, "Parkeringsplats uppdaterad");
        await loadSpaces();
      } catch (e) {
        print("Fel vid uppdatering: $e");
        showSnackbar(context, "Fel vid uppdatering");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "🅿️ Hantera parkeringsplatser",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: idController,
            decoration: const InputDecoration(labelText: "ID"),
          ),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: "Adress"),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: "Pris per timme"),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: addParkingSpace,
            child: const Text("Lägg till parkeringsplats"),
          ),
          const Divider(),
          ...spaces.map(
            (space) => ListTile(
              title: Text(space.address),
              subtitle: Text(
                  "ID: ${space.id} | Pris: ${space.pricePerHour.toStringAsFixed(2)} kr/h"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => editParkingSpace(space),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteParkingSpace(space.id),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
