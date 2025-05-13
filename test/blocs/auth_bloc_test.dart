import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parking_user/blocs/auth/auth_bloc.dart';
import 'package:parking_user/blocs/auth/auth_event.dart';
import 'package:parking_user/blocs/auth/auth_state.dart';
import 'package:parking_user/models/person.dart';
import 'package:mocktail/mocktail.dart';
import '../mocks/mock_repositories.dart';

void main() {
  late MockAuthService mockAuthService;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthService = MockAuthService();
    authBloc = AuthBloc(mockAuthService);
  });

  tearDown(() {
    authBloc.close();
  });

  final testUser = Person(name: 'Test', personalNumber: '123456-7890');

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] when login succeeds',
    build: () {
      when(() => mockAuthService.login(any()))
          .thenAnswer((_) async => testUser);
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginRequested('Test')),
    expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure] when login fails',
    build: () {
      when(() => mockAuthService.login(any())).thenThrow(Exception('error'));
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginRequested('Test')),
    expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthInitial] when logout is requested',
    build: () => authBloc,
    act: (bloc) => bloc.add(LogoutRequested()),
    expect: () => [isA<AuthInitial>()],
  );
}
