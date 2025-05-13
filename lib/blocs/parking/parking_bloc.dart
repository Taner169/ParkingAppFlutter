import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ApiService apiService;

  ParkingBloc({required this.apiService}) : super(ParkingInitial()) {
    on<LoadParkings>((event, emit) async {
      emit(ParkingLoading());
      try {
        final parkings = await apiService.getParkings();
        emit(ParkingLoaded(parkings));
      } catch (_) {
        emit(ParkingError("Kunde inte ladda parkeringar"));
      }
    });
  }
}
