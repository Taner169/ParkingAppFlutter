import '../../models/person.dart';

abstract class PersonEvent {}

class LoadPersons extends PersonEvent {}

class AddPerson extends PersonEvent {
  final Person person;
  AddPerson(this.person);
}

class DeletePerson extends PersonEvent {
  final String personalNumber;
  DeletePerson(this.personalNumber);
}

class UpdatePerson extends PersonEvent {
  final String oldPersonalNumber;
  final Person updatedPerson;
  UpdatePerson(this.oldPersonalNumber, this.updatedPerson);
}
