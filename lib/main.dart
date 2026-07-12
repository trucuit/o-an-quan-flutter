import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/menu_screen.dart';
import 'theme/game_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Responsive on all platforms: no forced orientation, edge-to-edge chrome.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ô Ăn Quan',
      debugShowCheckedModeBanner: false,
      theme: GameTheme.buildTheme(),
      builder: (context, child) {
        final scaler = MediaQuery.textScalerOf(context);
        // Clamp dynamic type so fixed game layouts stay usable (HIG/MD guidance).
        final clamped = scaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.25);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: clamped),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const MenuScreen(),
    );
  }
}