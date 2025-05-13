import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'parking_space_event.dart';
import 'parking_space_state.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  final ApiService apiService;

  ParkingSpaceBloc({required this.apiService}) : super(ParkingSpaceInitial()) {
    on<LoadParkingSpaces>((event, emit) async {
      emit(ParkingSpaceLoading());
      try {
        final spaces = await apiService.getParkingSpaces();
        emit(ParkingSpaceLoaded(spaces));
      } catch (_) {
        emit(ParkingSpaceError("Kunde inte ladda parkeringsplatser"));
      }
    });

    on<AddParkingSpace>((event, emit) async {
      emit(ParkingSpaceLoading());
      try {
        await apiService.addParkingSpace(event.space);
        final spaces = await apiService.getParkingSpaces();
        emit(ParkingSpaceLoaded(spaces));
      } catch (_) {
        emit(ParkingSpaceError("Kunde inte lägga till plats"));
      }
    });
  }
}
