// Starts and stops timer based on [startTimer] state
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/application/sound_helper.dart';
import 'package:flutter_tindeq/src/features/testing/application/test_actions.dart';
import 'package:flutter_tindeq/src/features/testing/domain/countdown_model.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'countdown_controller.g.dart';

void useTimer(VoidCallback callback, startTimer) {
  Duration? tick = const Duration(milliseconds: 20);
  final savedCallback = useRef<VoidCallback>(() => {});
  // ignore: body_might_complete_normally_nullable
  useEffect(() {
    savedCallback.value = callback;
  });

  useEffect(() {
    if (startTimer) {
      final timer = Timer.periodic(tick, (time) {
        savedCallback.value();
      });
      return () => timer.cancel();
    }
    return null;
  }, [startTimer]);
}

@riverpod
class StartTimer extends _$StartTimer {
  @override
  bool build() {
    return false;
  }

  void start() {
    state = true;
  }

  void end() {
    state = false;
  }
}

@riverpod
class Rep extends _$Rep {
  @override
  int build() {
    return 0;
  }

  void reset() {
    state = 0;
  }

  void dec() {
    state = state - 1;
  }

  void inc() {
    state = state + 1;
  }
}

(ValueNotifier<TimerState>, ValueNotifier<int>) getTimerState(
  ValueNotifier<TimerState> timerState,
  ValueNotifier<int> countdown,
  ValueNotifier<int> currentCountdown,
  TestTimes testTimes,
  WidgetRef ref,
) {
  int totalDuration = testTimes.countdownTime +
      (testTimes.hangTime + testTimes.restTime) * testTimes.reps;

  bool startTimer = ref.watch(startTimerProvider);
  int repValue = ref.watch(repProvider);
  var currentTestState = ref.watch(currentTestProvider);
  // debugPrint(
  //     "${timerState.value} $repValue ${countdown.value} ${currentCountdown.value} ");

  //Determine current state based on the elapsed countdown time
  if (startTimer) {
    // Play 3 second beep countdown at the end of:
    // - Countdown
    // - Hang and
    // - Rest periods
    if (isInCountdown(timerState, countdown, testTimes) |
        isInHang(timerState, countdown, repValue, testTimes) |
        isInRest(timerState, countdown, repValue, testTimes)) {
      playBeeps(currentCountdown.value);
    }
    if ((timerState.value == TimerState.complete) && startTimer) {
      timerState.value = TimerState.idle;
      currentCountdown.value = testTimes.countdownTime;
    } else if ((timerState.value == TimerState.idle)) {
      SoundHelper.playWhistle();
      SoundHelper.playGetReady();
      timerState.value = TimerState.countdown;
      currentCountdown.value = testTimes.countdownTime;
    } else if (isStartCountdown(timerState, countdown, testTimes)) {
      timerState.value = TimerState.countdown;
      currentCountdown.value = testTimes.countdownTime;
    } else if (countdown.value >= (totalDuration)) {
      // If countdown is complete reset the countdown times
      // Reset the Startimer provider
      // Mark the current test as complete
      // and start the results analysis
      currentCountdown.value = 0;
      countdown.value = 0;
      timerState.value = TimerState.complete;
      Future(() => ref.read(startTimerProvider.notifier).end());
      analyseResults(currentTestState.$1, ref);
      Future(() => ref
          .read(currentTestProvider.notifier)
          .setTest(currentTestState.$1, TestState.complete));
    } else if (isStartHang(timerState, countdown, repValue, testTimes)) {
      SoundHelper.playHang();
      timerState.value = TimerState.hang;
      currentCountdown.value = testTimes.hangTime;
      Future(() => ref.read(repProvider.notifier).inc());
    } else if (isStartRest(timerState, countdown, repValue, testTimes)) {
      SoundHelper.playRest();
      timerState.value = TimerState.rest;
      currentCountdown.value = testTimes.restTime;
    }
  }

  return (timerState, currentCountdown);
}

int startHangTime(Period period, int repValue, testTimes) {
  return testTimes.countdownTime +
      (testTimes.hangTime + testTimes.restTime) * (repValue - period.period);
}

int endHangTime(Period period, int repValue, testTimes) {
  return testTimes.countdownTime +
      (testTimes.hangTime + testTimes.restTime) * (repValue - period.period) +
      testTimes.hangTime;
}

bool isStartCountdown(timerState, countdown, testTimes) {
  return (timerState.value == TimerState.idle) &
      (countdown.value <= testTimes.countdownTime);
}

/// isStartHang if the current countdown time is at the start of a hang period
bool isStartHang(timerState, countdown, repValue, testTimes) {
  return ((timerState.value == TimerState.countdown) |
          (timerState.value == TimerState.rest)) &
      (countdown.value >= startHangTime(Period.next, repValue, testTimes)) &
      (countdown.value < endHangTime(Period.next, repValue, testTimes));
}

/// isStartRest if the current countdown time is at the start of a rest period
bool isStartRest(timerState, countdown, repValue, testTimes) {
  return (timerState.value == TimerState.hang) &
      (testTimes.restTime > 0) &
      (countdown.value >= endHangTime(Period.current, repValue, testTimes)) &
      (countdown.value < startHangTime(Period.next, repValue, testTimes));
}

bool isInCountdown(timerState, countdown, testTimes) {
  return (timerState.value == TimerState.countdown) &
      (countdown.value <= testTimes.countdownTime);
}

bool isInHang(timerState, countdown, repValue, testTimes) {
  bool isInHang = (timerState.value == TimerState.hang) &
      (countdown.value >= startHangTime(Period.current, repValue, testTimes)) &
      (countdown.value <= endHangTime(Period.current, repValue, testTimes));

  return isInHang;
}

bool isInRest(timerState, countdown, repValue, testTimes) {
  bool isInRest = (timerState.value == TimerState.rest) &
      (countdown.value >= endHangTime(Period.current, repValue, testTimes)) &
      (countdown.value <= startHangTime(Period.next, repValue, testTimes));

  return isInRest;
}
