import 'package:flutter/material.dart';
import 'utils/size_utils.dart';
import 'home_page.dart';
import 'constants/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

      home: HomePage(),
    );
  }
}
