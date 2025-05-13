import 'package:flutter/material.dart';
import '../models/person.dart';
import '../services/api_service.dart';

class PersonScreen extends StatefulWidget {
  final String username;
  const PersonScreen({super.key, required this.username});

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final apiService = ApiService(); // ✅ instans

  List<Person> persons = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPersons();
  }

  Future<void> loadPersons() async {
    try {
      final allPersons = await apiService.getPersons(); // ✅
      setState(() {
        persons = allPersons;
      });
    } catch (e) {
      print("Kunde inte ladda personer: $e");
    }
  }

  Future<void> addPerson() async {
    final name = nameController.text.trim();
    final number = numberController.text.trim();

    if (name.isNotEmpty && number.isNotEmpty) {
      final person = Person(name: name, personalNumber: number);
      try {
        await apiService.addPerson(person); // ✅
        nameController.clear();
        numberController.clear();
        await loadPersons();
      } catch (e) {
        print("Fel vid tillägg: $e");
      }
    }
  }

  Future<void> deletePerson(String personalNumber) async {
    try {
      await apiService.deletePerson(personalNumber); // ✅
      await loadPersons();
    } catch (e) {
      print("Fel vid borttagning: $e");
    }
  }

  Future<void> editPerson(Person originalPerson) async {
    final editNameController = TextEditingController(text: originalPerson.name);
    final editNumberController =
        TextEditingController(text: originalPerson.personalNumber);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Redigera person"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editNameController,
              decoration: const InputDecoration(labelText: "Namn"),
            ),
            TextField(
              controller: editNumberController,
              decoration: const InputDecoration(labelText: "Personnummer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Avbryt"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'name': editNameController.text,
              'personalNumber': editNumberController.text
            }),
            child: const Text("Spara"),
          ),
        ],
      ),
    );

    if (result != null &&
        result['name'] != null &&
        result['personalNumber'] != null) {
      try {
        final updatedPerson = Person(
          name: result['name']!,
          personalNumber: result['personalNumber']!,
        );
        await apiService.updatePerson(
          originalPerson.personalNumber, // ✅ korrekt
          updatedPerson,
        );
        await loadPersons();
      } catch (e) {
        print("Fel vid uppdatering: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? persons
        : persons.where((p) {
            final nameMatch = p.name.toLowerCase().contains(query);
            final numberMatch = p.personalNumber.toLowerCase().contains(query);
            return nameMatch || numberMatch;
          }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Personer")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Namn'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Personnummer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addPerson,
              child: const Text("➕ Lägg till person"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: '🔍 Sök person...',
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final person = filtered[index];
                  return ListTile(
                    title: Text('${person.name} - ${person.personalNumber}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editPerson(person),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deletePerson(person.personalNumber),
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
