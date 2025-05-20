import '../../models/person.dart';

abstract class PersonState {}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> persons;
  PersonLoaded(this.persons);
}

class PersonError extends PersonState {
  final String message;
  PersonError(this.message);
}
