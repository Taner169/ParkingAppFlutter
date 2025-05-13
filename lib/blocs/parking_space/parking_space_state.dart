import '../../models/parking_space.dart';

abstract class ParkingSpaceState {}

class ParkingSpaceInitial extends ParkingSpaceState {}

class ParkingSpaceLoading extends ParkingSpaceState {}

class ParkingSpaceLoaded extends ParkingSpaceState {
  final List<ParkingSpace> spaces;
  ParkingSpaceLoaded(this.spaces);
}

class ParkingSpaceError extends ParkingSpaceState {
  final String message;
  ParkingSpaceError(this.message);
}
