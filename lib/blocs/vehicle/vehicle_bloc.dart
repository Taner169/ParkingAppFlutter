import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final ApiService apiService;

  VehicleBloc({required this.apiService}) : super(VehicleInitial()) {
    on<LoadVehicles>((event, emit) async {
      emit(VehicleLoading());
      try {
        final vehicles = await apiService.getVehicles();
        emit(VehicleLoaded(vehicles));
      } catch (_) {
        emit(VehicleError("Kunde inte ladda fordon"));
      }
    });
  }
}
