import 'dart:async';
import 'package:flutter/material.dart';
import '../services/gamepad_service.dart';
import 'nintendo64_games_page.dart';

const _consoles = ['Nintendo 64'];

class ConsoleSelectorPage extends StatefulWidget {
  const ConsoleSelectorPage({super.key});

  @override
  State<ConsoleSelectorPage> createState() => _ConsoleSelectorPageState();
}

class _ConsoleSelectorPageState extends State<ConsoleSelectorPage> {
  int _selectedIndex = 0;
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
    switch (action) {
      case GamepadAction.up:
        setState(() {
          _selectedIndex = (_selectedIndex - 1).clamp(0, _consoles.length - 1);
        });
      case GamepadAction.down:
        setState(() {
          _selectedIndex = (_selectedIndex + 1).clamp(0, _consoles.length - 1);
        });
      case GamepadAction.confirm:
        _navigate();
      default:
        break;
    }
  }

  void _navigate() {
    final console = _consoles[_selectedIndex];
    if (console == 'Nintendo 64') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Nintendo64GamesPage()),
      );
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
              'SELECT CONSOLE',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                letterSpacing: 6,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _consoles.length,
              itemBuilder: (context, index) => _ConsoleItem(
                name: _consoles[index],
                selected: index == _selectedIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsoleItem extends StatelessWidget {
  const _ConsoleItem({required this.name, required this.selected});

  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontSize: 24,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 2,
          ),
        ),
    );
  }
}
