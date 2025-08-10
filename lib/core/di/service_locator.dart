import 'package:get_it/get_it.dart';

import '../database/database.dart';
import '../repositories/event_repository.dart';
import '../repositories/drift_event_repository.dart';
import '../../features/events/bloc/events_bloc.dart';
import '../../features/event_detail/bloc/event_detail_bloc.dart';
import '../../features/import_export/cubit/import_export_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Database
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Repositories
  sl.registerLazySingleton<EventRepository>(
    () => DriftEventRepository(sl<AppDatabase>()),
  );

  // BLoCs and Cubits
  sl.registerFactory<EventsBloc>(
    () => EventsBloc(repository: sl<EventRepository>()),
  );

  sl.registerFactory<EventDetailBloc>(
    () => EventDetailBloc(repository: sl<EventRepository>()),
  );

  sl.registerFactory<ImportExportCubit>(
    () => ImportExportCubit(repository: sl<EventRepository>()),
  );
}

Future<void> resetServiceLocator() async {
  await sl.reset();
  await setupServiceLocator();
}
