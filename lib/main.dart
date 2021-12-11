import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soon/data/skipped_annonces_repository.dart';
import 'package:soon/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SkippedAnnoncesRepository.setPreferences(await SharedPreferences.getInstance());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soon',
      theme: ThemeData(primarySwatch: primaryBlack),
      home: const MainPage(),
    );
  }
}

const MaterialColor primaryBlack = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Colors.black12,
    100: Colors.black12,
    200: Colors.black26,
    300: Colors.black38,
    400: Colors.black38,
    500: Colors.black,
    600: Colors.black54,
    700: Colors.black54,
    800: Colors.black87,
    900: Colors.black87,
  },
);
