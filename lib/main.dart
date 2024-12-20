import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/views/add_device_screen.dart';
import 'package:envirosense/presentation/views/add_room_screen.dart';
import 'package:envirosense/presentation/views/email_verification_screen.dart';
import 'package:envirosense/presentation/views/main_screen.dart';
import 'package:envirosense/presentation/views/onboarding_screen.dart';
import 'package:envirosense/presentation/views/statistics_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:envirosense/presentation/views/login_screen.dart';
import 'services/logging_service.dart';
import 'presentation/views/room_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  LoggingService.initialize();

  runApp(EnviroSenseApp(isFirstTime: isFirstTime));
}

class EnviroSenseApp extends StatefulWidget {
  final bool isFirstTime;

  const EnviroSenseApp({super.key, required this.isFirstTime});

  @override
  State<EnviroSenseApp> createState() => _EnviroSenseAppState();
}

class _EnviroSenseAppState extends State<EnviroSenseApp> {
  Widget _initialScreen = const LoginScreen();

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    if (widget.isFirstTime) {
      setState(() {
        _initialScreen = const OnboardingScreen();
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? timestamp = prefs.getInt('loginTimestamp');

    if (timestamp != null) {
      DateTime loginTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateTime now = DateTime.now();
      Duration difference = now.difference(loginTime);

      if (difference.inDays < 2) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          setState(() {
            _initialScreen = const MainScreen();
          });
          return;
        }
      }

      // If login is expired or user is not authenticated
      prefs.remove('loginTimestamp');
      await FirebaseAuth.instance.signOut();
    }

    // Default to LoginScreen
    setState(() {
      _initialScreen = const LoginScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnviroSense',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.whiteColor,
          selectionColor: AppColors.secondaryColor,
          selectionHandleColor: AppColors.secondaryColor,
        ),
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.whiteColor,
        appBarTheme: const AppBarTheme(
          color: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.whiteColor),
          toolbarTextStyle:
              TextStyle(color: AppColors.whiteColor, fontSize: 20),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.secondaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: _initialScreen,
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/emailVerification': (context) => EmailVerificationScreen(
              email: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['email'],
            ),
        '/addRoom': (context) => const AddRoomScreen(),
        '/addDevice': (context) => const AddDeviceScreen(),
        '/statisticsDetail': (context) => const StatisticsDetailScreen(),
        '/roomOverview': (context) => RoomOverviewScreen(
              roomName: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['roomName'],
              roomId: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['roomId'],
            ),
        '/deviceOverview': (context) => DeviceOverviewScreen(
              deviceName: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['deviceName'],
              deviceId: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['deviceId'],
            ),
      },
    );
  }
}
