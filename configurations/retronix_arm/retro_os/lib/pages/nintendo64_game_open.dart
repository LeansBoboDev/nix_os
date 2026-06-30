import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/debug_logger.dart';
import '../utils/devices.dart';

const _n64Core =
    '/run/current-system/sw/lib/retroarch/cores/mupen64plus_next_libretro.so';

class Nintendo64GameOpen extends StatefulWidget {
  const Nintendo64GameOpen({super.key, required this.gameName});

  final String gameName;

  @override
  State<Nintendo64GameOpen> createState() => _Nintendo64GameOpenState();
}

class _Nintendo64GameOpenState extends State<Nintendo64GameOpen> {
  @override
  void initState() {
    super.initState();
    _openGame();
  }

  Future<void> _openGame() async {
    DebugLogger.log('[Nintendo64GameOpen] opening game: ${widget.gameName}');

    final romPath = await getGameFilePath('Nintendo 64', widget.gameName);

    if (romPath == null) {
      DebugLogger.log('[Nintendo64GameOpen] ROM not found for: ${widget.gameName}');
      if (mounted) Navigator.pop(context);
      return;
    }

    DebugLogger.log('[Nintendo64GameOpen] core: $_n64Core');
    DebugLogger.log('[Nintendo64GameOpen] ROM: $romPath');
    await Process.start(
      'retroarch',
      ['-L', _n64Core, romPath],
      mode: ProcessStartMode.detached,
    );
    DebugLogger.log('[Nintendo64GameOpen] retroarch launched');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white54),
            const SizedBox(height: 32),
            Text(
              'Abrindo ${widget.gameName}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 20,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
