import '../../models/parking.dart';

abstract class ParkingEvent {}

class LoadParkings extends ParkingEvent {}

class StartParking extends ParkingEvent {
  final Parking parking;
  StartParking(this.parking);
}

class EndParking extends ParkingEvent {
  final Parking parking;
  EndParking(this.parking);
}
