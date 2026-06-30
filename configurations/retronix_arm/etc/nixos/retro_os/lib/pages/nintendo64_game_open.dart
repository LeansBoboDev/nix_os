import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../services/gamepad_service.dart';
import '../utils/debug_logger.dart';
import '../utils/devices.dart';
import '../utils/settings_service.dart';

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
      if (mounted) Navigator.pop(context, 'ROM não encontrada para: ${widget.gameName}');
      return;
    }

    final corePath = await SettingsService.instance.n64CorePath();
    if (!File(corePath).existsSync()) {
      DebugLogger.log('[Nintendo64GameOpen] core not found: $corePath');
      if (mounted) Navigator.pop(context, 'Core não encontrado: $corePath');
      return;
    }

    try {
      await SettingsService.instance.applyN64CoreOptions();

      DebugLogger.log('[Nintendo64GameOpen] core: $corePath');
      DebugLogger.log('[Nintendo64GameOpen] ROM: $romPath');

      final process = await Process.start(
        'retroarch',
        ['-L', corePath, '--fullscreen', romPath],
      );
      DebugLogger.log('[Nintendo64GameOpen] retroarch launched (pid: ${process.pid})');

      final sub = _watchExitCombo(process);

      final exitCode = await process.exitCode;
      sub.cancel();
      DebugLogger.log('[Nintendo64GameOpen] retroarch exited with code: $exitCode');

      if (!mounted) return;
      if (exitCode != 0 && exitCode != -15) {
        // -15 = SIGTERM (kill normal), não é erro
        Navigator.pop(context, 'RetroArch encerrou com erro (código $exitCode)');
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      DebugLogger.log('[Nintendo64GameOpen] failed to launch retroarch: $e');
      if (mounted) Navigator.pop(context, 'Falha ao iniciar RetroArch: $e');
    }
  }

  // Escuta Start + Select dentro de 600ms para matar o processo.
  StreamSubscription<GamepadAction> _watchExitCombo(Process process) {
    final recent = <GamepadAction>{};

    return GamepadService.instance.actions.listen((action) {
      if (action != GamepadAction.start && action != GamepadAction.select) return;

      recent.add(action);
      Future.delayed(const Duration(milliseconds: 600), () => recent.remove(action));

      if (recent.contains(GamepadAction.start) &&
          recent.contains(GamepadAction.select)) {
        DebugLogger.log('[Nintendo64GameOpen] exit combo detected — killing retroarch');
        process.kill();
      }
    });
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
            const SizedBox(height: 16),
            const Text(
              'Start + Select para sair',
              style: TextStyle(color: Colors.white24, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
