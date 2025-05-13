import 'package:mocktail/mocktail.dart';
import 'package:parking_user/services/api_service.dart';
import 'package:parking_user/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockApiService extends Mock implements ApiService {}
