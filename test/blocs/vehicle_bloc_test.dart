import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_user/blocs/vehicle/vehicle_bloc.dart';
import 'package:parking_user/blocs/vehicle/vehicle_event.dart';
import 'package:parking_user/blocs/vehicle/vehicle_state.dart';
import 'package:parking_user/models/vehicle.dart';
import '../mocks/mock_repositories.dart'; // ✅ du använder det nu

class FakeVehicle extends Fake implements Vehicle {}

void main() {
  late MockApiService mockApi;

  setUpAll(() {
    registerFallbackValue(FakeVehicle());
  });

  setUp(() {
    mockApi = MockApiService();
  });

  final vehicle = Vehicle(
    registrationNumber: 'ABC123',
    type: 'Bil',
    owner: '123456-7890',
  );

  blocTest<VehicleBloc, VehicleState>(
    'emits [VehicleLoading, VehicleLoaded] on LoadVehicles',
    build: () {
      when(() => mockApi.getVehicles()).thenAnswer((_) async => [vehicle]);
      return VehicleBloc(apiService: mockApi);
    },
    act: (bloc) => bloc.add(LoadVehicles()),
    expect: () => [isA<VehicleLoading>(), isA<VehicleLoaded>()],
  );
}
