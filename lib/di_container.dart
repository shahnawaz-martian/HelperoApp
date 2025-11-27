import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:helpero/feature/bookings/controllers/order_controller.dart';
import 'package:helpero/feature/bookings/domain/repositories/order_repository.dart';
import 'package:helpero/feature/bookings/domain/repositories/order_repository_interface.dart';
import 'package:helpero/feature/bookings/domain/services/order_service.dart';
import 'package:helpero/feature/bookings/domain/services/order_service_interface.dart';
import 'package:helpero/feature/profile/controllers/address_controller.dart';
import 'package:helpero/feature/profile/controllers/profile_contrroller.dart';
import 'package:helpero/feature/profile/domain/repositories/profile_repository.dart';
import 'package:helpero/feature/profile/domain/repositories/profile_repository_interface.dart';
import 'package:helpero/feature/profile/domain/services/profile_service.dart';
import 'package:helpero/feature/profile/domain/services/profile_service_interface.dart';
import 'package:helpero/theme/controllers/theme_controller.dart';
import 'package:helpero/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'feature/auth/domain/repositories/auth_repository.dart';
import 'feature/auth/domain/repositories/auth_repository_interface.dart';
import 'feature/auth/domain/services/auth_service.dart';
import 'feature/auth/domain/services/auth_service_interface.dart';
import 'feature/auth/controllers/auth_controller.dart';
import 'helper/location_controller.dart';
import 'helper/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(
    () => DioClient(
      AppConstants.baseUrl,
      sl(),
      loggingInterceptor: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Repository layer
  sl.registerLazySingleton<AuthRepoInterface>(
    () => AuthRepository(dioClient: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ProfileRepositoryInterface>(
    () => ProfileRepository(dioClient: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<OrderRepositoryInterface>(() => OrderRepository(dioClient: sl()));

  // Service layer
  sl.registerLazySingleton<AuthServiceInterface>(
    () => AuthService(authRepoInterface: sl()),
  );
  sl.registerLazySingleton<ProfileServiceInterface>(
    () => ProfileService(profileRepositoryInterface: sl()),
  );
  sl.registerLazySingleton<OrderServiceInterface>(() => OrderService(orderRepositoryInterface: sl()));

  // Controller layer
  sl.registerLazySingleton(() => AuthController(authServiceInterface: sl()));
  sl.registerLazySingleton(
    () => ProfileController(profileServiceInterface: sl()),
  );
  sl.registerLazySingleton(() => ThemeController(sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderController(orderServiceInterface: sl()));
  sl.registerLazySingleton(() => LocationController(),);
  sl.registerLazySingleton(() => AddressController(),);
}
