import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/menu_screen.dart';
import 'theme/game_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ô Ăn Quan',
      debugShowCheckedModeBanner: false,
      theme: GameTheme.buildTheme(),
      home: const MenuScreen(),
    );
  }
}