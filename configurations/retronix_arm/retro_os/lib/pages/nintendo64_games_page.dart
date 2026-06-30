import 'dart:async';
import 'package:flutter/material.dart';
import '../services/gamepad_service.dart';

class Nintendo64GamesPage extends StatefulWidget {
  const Nintendo64GamesPage({super.key});

  @override
  State<Nintendo64GamesPage> createState() => _Nintendo64GamesPageState();
}

class _Nintendo64GamesPageState extends State<Nintendo64GamesPage> {
  late final StreamSubscription<GamepadAction> _sub;

  @override
  void initState() {
    super.initState();
    _sub = GamepadService.instance.actions.listen(_handleAction);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _handleAction(GamepadAction action) {
    if (action == GamepadAction.back) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Text(
              'NINTENDO 64',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                letterSpacing: 6,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Nenhum jogo adicionado ainda.',
                style: TextStyle(color: Colors.white30, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
