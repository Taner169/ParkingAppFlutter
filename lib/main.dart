import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/vehicle/vehicle_bloc.dart';
import 'blocs/parking/parking_bloc.dart';
import 'blocs/parking_space/parking_space_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(ParkingApp());
}

class ParkingApp extends StatefulWidget {
  @override
  State<ParkingApp> createState() => _ParkingAppState();
}

class _ParkingAppState extends State<ParkingApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthService()),
        ),
        BlocProvider<VehicleBloc>(
          create: (_) => VehicleBloc(apiService: apiService),
        ),
        BlocProvider<ParkingBloc>(
          create: (_) => ParkingBloc(apiService: apiService),
        ),
        BlocProvider<ParkingSpaceBloc>(
          create: (_) => ParkingSpaceBloc(apiService: apiService),
        ),
      ],
      child: MaterialApp(
        title: 'Parkeringsappen',
        debugShowCheckedModeBanner: false,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return HomeScreen(
                username: state.user.name,
                toggleTheme: toggleTheme,
                isDarkMode: isDarkMode,
              );
            } else {
              return LoginScreen(
                toggleTheme: toggleTheme,
                isDarkMode: isDarkMode,
              );
            }
          },
        ),
      ),
    );
  }
}
