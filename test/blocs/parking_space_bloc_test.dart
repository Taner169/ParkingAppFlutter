import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_user/blocs/parking_space/parking_space_bloc.dart';
import 'package:parking_user/blocs/parking_space/parking_space_event.dart';
import 'package:parking_user/blocs/parking_space/parking_space_state.dart';
import 'package:parking_user/models/parking_space.dart';
import '../mocks/mock_api_service.dart'; // 👈 här

class FakeParkingSpace extends Fake implements ParkingSpace {}

void main() {
  late MockApiService mockApi;

  setUpAll(() {
    registerFallbackValue(FakeParkingSpace());
  });

  setUp(() {
    mockApi = MockApiService();
  });

  final space = ParkingSpace(id: 'P1', address: 'Gatan 1', pricePerHour: 10);

  blocTest<ParkingSpaceBloc, ParkingSpaceState>(
    'emits [ParkingSpaceLoading, ParkingSpaceLoaded] on LoadParkingSpaces',
    build: () {
      when(() => mockApi.getParkingSpaces()).thenAnswer((_) async => [space]);
      return ParkingSpaceBloc(apiService: mockApi);
    },
    act: (bloc) => bloc.add(LoadParkingSpaces()),
    expect: () => [isA<ParkingSpaceLoading>(), isA<ParkingSpaceLoaded>()],
  );

  blocTest<ParkingSpaceBloc, ParkingSpaceState>(
    'emits ParkingSpaceError on AddParkingSpace failure',
    build: () {
      when(() => mockApi.addParkingSpace(any())).thenThrow(Exception());
      return ParkingSpaceBloc(apiService: mockApi);
    },
    act: (bloc) => bloc.add(AddParkingSpace(space)),
    expect: () => [isA<ParkingSpaceLoading>(), isA<ParkingSpaceError>()],
  );
}
