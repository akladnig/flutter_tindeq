import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

// ignore: avoid_classes_with_only_static_members
class SoundHelper {
  static final Soundpool _soundpool = Soundpool.fromOptions(
      options: const SoundpoolOptions(
    streamType: StreamType.music,
  ));
  //Beeps
  static late int _beepLowId;
  static late int _beepHighId;
  static late int _beepId;
  static late int _whistleId;
  //Voices
  static late int _getReadyId;
  static late int _hangId;
  static late int _restId;

  static Future<void> loadSounds() async {
    debugPrint("load sounds");
    await _loadSounds();
  }

  static Future<void> _loadSounds() async {
    var beepLow = await rootBundle.load('assets/sound/beep_low.wav');
    var beepHigh = await rootBundle.load('assets/sound/beep_high.wav');
    var beep = await rootBundle.load('assets/sound/beep-07a.mp3');
    var whistle =
        await rootBundle.load('assets/sound/sport_whistle_short_toot.mp3');

    var getReady = await rootBundle.load('assets/sound/get_ready.mp3');
    var hang = await rootBundle.load('assets/sound/hang.mp3');
    var rest = await rootBundle.load('assets/sound/rest.mp3');

    _beepLowId = await _soundpool.load(beepLow);
    _beepHighId = await _soundpool.load(beepHigh);
    _beepId = await _soundpool.load(beep);
    _whistleId = await _soundpool.load(whistle);

    _getReadyId = await _soundpool.load(getReady);
    _hangId = await _soundpool.load(hang);
    _restId = await _soundpool.load(rest);
  }

  static void playBeepLow() {
    _soundpool.play(_beepLowId);
  }

  static void playBeepHigh() {
    _soundpool.play(_beepHighId);
  }

  static void playBeep() {
    _soundpool.play(_beepId);
  }

  static void playWhistle() {
    _soundpool.play(_whistleId);
  }

  static void playGetReady() {
    _soundpool.play(_getReadyId);
  }

  static void playHang() {
    _soundpool.play(_hangId);
  }

  static void playRest() {
    _soundpool.play(_restId);
  }
}

/// A beep will play on the last 3 seconds of a hang or rest period
/// and a whistle will play on end of the hang or rest period.
/// A whistle will take precedence over a beep if the time is 3 seconds
playBeeps(int time) {
  var beepTimes = {3, 2, 1};
  if (time == 0) {
    SoundHelper.playWhistle();
  } else if (beepTimes.contains(time)) {
    SoundHelper.playBeep();
  }
}
