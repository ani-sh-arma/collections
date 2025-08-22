import 'dart:developer';

import 'package:get_it/get_it.dart';

import '../database/database.dart';
import '../repositories/event_repository.dart';
import '../repositories/drift_event_repository.dart';
import '../../features/events/cubit/events_cubit.dart';
import '../../features/event_detail/cubit/event_detail_cubit.dart';
import '../../features/import_export/cubit/import_export_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  try {
    // Database
    sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

    // Repositories
    sl.registerLazySingleton<EventRepository>(
      () => DriftEventRepository(sl<AppDatabase>()),
    );

    // Cubits
    sl.registerFactory<EventsCubit>(
      () => EventsCubit(repository: sl<EventRepository>()),
    );

    sl.registerFactory<EventDetailCubit>(
      () => EventDetailCubit(repository: sl<EventRepository>()),
    );

    sl.registerFactory<ImportExportCubit>(
      () => ImportExportCubit(repository: sl<EventRepository>()),
    );
  } catch (e) {
    log('Error setting up service locator: $e');
    rethrow;
  }
}

Future<void> resetServiceLocator() async {
  await sl.reset();
  await setupServiceLocator();
}
