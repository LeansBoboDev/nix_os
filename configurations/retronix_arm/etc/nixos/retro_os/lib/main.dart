import 'package:flutter/material.dart';
import 'services/gamepad_service.dart';
import 'pages/console_selector_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GamepadService.instance.init();
  runApp(const RetroOsApp());
}

class RetroOsApp extends StatelessWidget {
  const RetroOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RetroOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ConsoleSelectorPage(),
    );
  }
}
