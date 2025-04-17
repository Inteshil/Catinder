import 'package:flutter/material.dart';
import 'package:catinder/di.dart';
import 'package:catinder/presentation/pages/home_page.dart';

void main() async {
  print('Starting application...');
  WidgetsFlutterBinding.ensureInitialized();
  print('Flutter binding initialized');
  
  await init();
  print('DI container initialized');
  
  runApp(const CatinderApp());
}

class CatinderApp extends StatelessWidget {
  const CatinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building CatinderApp');
    return MaterialApp(
      title: 'Catinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
