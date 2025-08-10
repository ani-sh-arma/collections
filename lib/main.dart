import 'package:flutter/material.dart';

import 'utils/size_utils.dart';
import 'constants/theme.dart';
import 'core/di/service_locator.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
