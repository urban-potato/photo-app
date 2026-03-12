import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../../features/photo/data/data_sources/photo.dart';
import '../../features/photo/data/repositpries/photo.dart';
import '../../features/photo/data/services/index.dart' show ExifService;
import '../../features/photo/domain/repositories/photo.dart';
import '../../features/photo/domain/services/index.dart' show ExifServiceI;
import '../../features/photo/presentation/provider/index.dart' show PhotoCubit;
import '../../features/photo/presentation/screens/camera/provider/index.dart'
    show CameraCubit;
import '../../shared/data/repositories/index.dart' show SettingsRepository;
import '../../shared/domain/repositories/index.dart' show SettingsRepositoryI;
import '../../shared/presentation/providers/index.dart'
    show NavigationProviderI;
import '../../shared/presentation/providers/settings/index.dart';
import '../app_config.dart';
import '../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import '../navigation/index.dart' show NavigationProvider;

final di = GetIt.instance;

void initializeDependencies({required AppConfig config}) {
  di.registerSingleton<Talker>(config.talker);

  di.registerSingleton<NavigationProviderI>(const NavigationProvider());

  final sharedPreferencesAsync = SharedPreferencesAsync();
  di.registerSingleton<SharedPreferencesAsync>(sharedPreferencesAsync);

  di.registerSingleton<PhotoDataSource>(PhotoDataSource(talker: di<Talker>()));

  di.registerSingleton<ExifServiceI>(ExifService(talker: di<Talker>()));

  di.registerSingleton<PhotoRepositoryI>(
    PhotoRepository(
      talker: di<Talker>(),
      preferencesAsync: di<SharedPreferencesAsync>(),
      photoDataSource: di<PhotoDataSource>(),
      exifService: di<ExifServiceI>(),
    ),
  );

  di.registerFactory<PhotoCubit>(
    () => PhotoCubit(photoRepository: di<PhotoRepositoryI>()),
  );
  di.registerFactory<CameraCubit>(
    () => CameraCubit(
      photoRepository: di<PhotoRepositoryI>(),
      talker: di<Talker>(),
    ),
  );

  di.registerSingleton<ResponsiveSizeCubit>(ResponsiveSizeCubit());

  di.registerSingleton<SettingsRepositoryI>(
    SettingsRepository(
      prefs: di<SharedPreferencesAsync>(),
      talker: di<Talker>(),
    ),
  );

  di.registerSingleton<SettingsCubit>(
    SettingsCubit(
      settingsRepo: di<SettingsRepositoryI>(),
      talker: di<Talker>(),
    ),
  );
}
