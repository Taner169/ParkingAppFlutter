import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_user/blocs/parking/parking_bloc.dart';
import 'package:parking_user/blocs/parking/parking_event.dart';
import 'package:parking_user/blocs/parking/parking_state.dart';
import 'package:parking_user/models/parking.dart';
import '../mocks/mock_api_service.dart';

class FakeParking extends Fake implements Parking {}

void main() {
  late MockApiService mockApi;
  late ParkingBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeParking());
  });

  setUp(() {
    mockApi = MockApiService();
    bloc = ParkingBloc(apiService: mockApi); // 👈 måste passas in!
  });

  final testParking = Parking(
    vehicle: 'ABC123',
    space: 'P1',
    startTime: DateTime.now().toIso8601String(),
    owner: '123456-7890',
  );

  blocTest<ParkingBloc, ParkingState>(
    'emits [ParkingLoading, ParkingLoaded] on LoadParkings',
    build: () {
      when(() => mockApi.getParkings()).thenAnswer((_) async => [testParking]);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadParkings()),
    expect: () => [isA<ParkingLoading>(), isA<ParkingLoaded>()],
  );
}
