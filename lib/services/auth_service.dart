import '../models/person.dart';

class AuthService {
  // Simulerad inloggningstjänst som returnerar en Person
  Future<Person> login(String name) async {
    // Här används ett placeholder-personnummer
    return Person(name: name, personalNumber: '000000-0000');
  }
}
