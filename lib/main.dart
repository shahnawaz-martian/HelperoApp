import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpero/feature/bookings/controllers/order_controller.dart';
import 'package:helpero/feature/profile/controllers/address_controller.dart';
import 'package:helpero/feature/profile/controllers/profile_contrroller.dart';
import 'package:helpero/helper/location_controller.dart';
import 'package:helpero/theme/controllers/theme_controller.dart';
import 'package:helpero/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:helpero/feature/auth/view/sign_in_screen.dart';
import 'data/local/cache_response.dart';
import 'di_container.dart' as di;
import 'feature/auth/controllers/auth_controller.dart';
import 'feature/navigation/bottom_navigation_bar_screen.dart';
import 'helper/location_helper.dart';
import 'helper/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final database = AppDatabase();

// Custom PageTransitionsBuilder with no animation
class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // optional (allows upside-down)
  ]);
  await di.init();

  // Default initialization for all platforms
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  await NotificationService.initialize();

  RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();

  if (initialMessage != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.handleMessageClick(initialMessage.data);
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<ThemeController>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileController>()),
        ChangeNotifierProvider(create: (_) => di.sl<OrderController>()),
        ChangeNotifierProvider(create: (_) => di.sl<LocationController>()),
        ChangeNotifierProvider(create: (_) => di.sl<AddressController>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> checkLogin(BuildContext context) async {
    final authController = context.read<AuthController>();
    return authController.isLoggedIn();
  }

  @override
  void initState() {
    super.initState();
    askPermissionsInOrder();
  }

  Future<void> askPermissionsInOrder() async {
    // Ask notification permission first
    await NotificationService.requestPermission();
    await NotificationService.getDeviceToken().then((value) {
      log("FCM Token: $value");
    });

    // Delay to allow Android UI to settle
    await Future.delayed(const Duration(milliseconds: 200));

    // Ask location permission
    await LocationHelper.requestLocationPermission();

    Get.context!.read<LocationController>().fetchCurrentAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return FutureBuilder<bool>(
          future: checkLogin(context),
          builder: (context, snapshot) {
            final isLoggedIn = snapshot.data ?? false;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Helpero',
              theme: lightTheme.copyWith(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
                    TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
                  },
                ),
              ),
              themeMode: ThemeMode.light,
              home: isLoggedIn
                  ? const BottomNavigationBarScreen()
                  : const SignInScreen(),
              navigatorKey: navigatorKey,
            );
          },
        );
      },
    );
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState? get navigator => navigatorKey.currentState;
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
