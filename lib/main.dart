import 'dart:io';
import 'package:collections/features/events/pages/events_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'utils/size_utils.dart';
import 'constants/theme.dart';
import 'constants/colors.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.bgDeep,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.bgDeep,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

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
      title: 'Collections',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const EventsPage(),
    );
  }
}
