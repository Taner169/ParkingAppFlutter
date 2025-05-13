import '../../models/vehicle.dart';

abstract class VehicleEvent {}

class LoadVehicles extends VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicle(this.vehicle);
}

class DeleteVehicle extends VehicleEvent {
  final String regNumber;
  DeleteVehicle(this.regNumber);
}
