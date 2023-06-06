import 'package:flutter/material.dart';

enum TimerState {
  // Waiting for the Tindeq to connect
  waiting('Waiting for Progressor', Colors.red),
  idle('Idle', Colors.orange),
  countdown('CountDown', Colors.orange),
  hang('Hang', Colors.green),
  rest('Rest', Colors.red),
  complete('Complete', Colors.orange);

  const TimerState(this.label, this.colour);
  final String label;
  final MaterialColor colour;
}

enum ButtonState {
  waiting('Waiting for Progressor', Colors.red),
  // idle('Idle', Colors.orange),
  start('Start Test', Colors.green),
  complete('Test Complete', Colors.orange);

  const ButtonState(this.label, this.colour);
  final String label;
  final MaterialColor colour;
}

//Enum for the current rep period
enum Period {
  current(1),
  next(0);

  const Period(this.period);
  final int period;
}
