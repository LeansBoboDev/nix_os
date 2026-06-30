import 'dart:async';
import 'package:flutter/material.dart';
import '../services/gamepad_service.dart';

/// Shows a yes/no confirmation dialog navigable by gamepad.
/// Returns true if confirmed, false otherwise.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String message,
  String labelYes = 'Sim',
  String labelNo = 'Não',
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ConfirmDialog(
      message: message,
      labelYes: labelYes,
      labelNo: labelNo,
    ),
  );
  return result ?? false;
}

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.message,
    required this.labelYes,
    required this.labelNo,
  });

  final String message;
  final String labelYes;
  final String labelNo;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  // false = No (safe default), true = Yes
  bool _selectedYes = false;
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
      case GamepadAction.left:
      case GamepadAction.right:
        setState(() => _selectedYes = !_selectedYes);
      case GamepadAction.confirm:
        Navigator.pop(context, _selectedYes);
      case GamepadAction.back:
        Navigator.pop(context, false);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.message,
              style: const TextStyle(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DialogOption(label: widget.labelNo, selected: !_selectedYes),
                const SizedBox(width: 24),
                _DialogOption(label: widget.labelYes, selected: _selectedYes),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogOption extends StatelessWidget {
  const _DialogOption({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontSize: 18,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
