import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;

import '../../features/photo/data/data_sources/photo.dart';
import '../../features/photo/data/repositpries/photo.dart';
import '../../features/photo/domain/repositories/photo.dart';
import '../../features/photo/presentation/provider/index.dart' show PhotoCubit;
import '../../features/photo/presentation/screens/camera/provider/index.dart'
    show CameraCubit;
import '../app_config.dart';
import '../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

final di = GetIt.instance;

void initializeDependencies({required AppConfig config}) {
  final sharedPreferencesAsync = SharedPreferencesAsync();
  di.registerSingleton<SharedPreferencesAsync>(sharedPreferencesAsync);

  di.registerSingleton<PhotoDataSource>(PhotoDataSource(talker: config.talker));

  di.registerSingleton<PhotoRepositoryI>(
    PhotoRepository(
      photoDataSource: di<PhotoDataSource>(),
      preferencesAsync: di<SharedPreferencesAsync>(),
      talker: config.talker,
    ),
  );

  di.registerFactory<PhotoCubit>(
    () => PhotoCubit(photoRepository: di<PhotoRepositoryI>()),
  );
  di.registerFactory<CameraCubit>(
    () => CameraCubit(
      photoRepository: di<PhotoRepositoryI>(),
      talker: config.talker,
    ),
  );

  di.registerSingleton<ResponsiveSizeCubit>(ResponsiveSizeCubit());
}
