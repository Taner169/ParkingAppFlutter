import '../../models/parking_space.dart';

abstract class ParkingSpaceEvent {}

class LoadParkingSpaces extends ParkingSpaceEvent {}

class AddParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace space;
  AddParkingSpace(this.space);
}
