import 'dart:async';
import 'package:flutter/material.dart';

class CountdownDialog extends StatefulWidget {
  final int initialSeconds;

  const CountdownDialog({super.key, required this.initialSeconds});

  @override
  State<CountdownDialog> createState() => CountdownDialogState();
}

class CountdownDialogState extends State<CountdownDialog> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.initialSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('The game starts in ${widget.initialSeconds} seconds.'),
      content: Text('$_secondsLeft'),
    );
  }
}
