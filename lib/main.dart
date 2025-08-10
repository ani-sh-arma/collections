import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'utils/size_utils.dart';
import 'constants/theme.dart';
import 'core/di/service_locator.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite on Android
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }

  // Setup dependency injection
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SizeUtils sizeUtils = SizeUtils();
    sizeUtils.init(context);

    return MaterialApp(
      title: 'Create Flutter App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      home: const HomePage(),
    );
  }
}
