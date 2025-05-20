import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/person.dart';
import '../../services/api_service.dart';
import 'person_event.dart';
import 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final ApiService apiService;

  PersonBloc({required this.apiService}) : super(PersonInitial()) {
    on<LoadPersons>((event, emit) async {
      emit(PersonLoading());
      try {
        final persons = await apiService.getPersons();
        emit(PersonLoaded(persons));
      } catch (e) {
        emit(PersonError("Kunde inte ladda personer"));
      }
    });

    on<AddPerson>((event, emit) async {
      try {
        await apiService.addPerson(event.person);
        final persons = await apiService.getPersons();
        emit(PersonLoaded(persons));
      } catch (e) {
        emit(PersonError("Kunde inte lägga till person"));
      }
    });

    on<DeletePerson>((event, emit) async {
      try {
        await apiService.deletePerson(event.personalNumber);
        final persons = await apiService.getPersons();
        emit(PersonLoaded(persons));
      } catch (e) {
        emit(PersonError("Kunde inte ta bort person"));
      }
    });

    on<UpdatePerson>((event, emit) async {
      try {
        await apiService.updatePerson(
            event.oldPersonalNumber, event.updatedPerson);
        final persons = await apiService.getPersons();
        emit(PersonLoaded(persons));
      } catch (e) {
        emit(PersonError("Kunde inte uppdatera person"));
      }
    });
  }
}
