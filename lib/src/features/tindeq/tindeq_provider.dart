import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tindeq_provider.g.dart';

//TODO timer with a delay to simulate connection to the Tindeq
tindeq() async {
  debugPrint("Before Delay");

  await Future.delayed(const Duration(seconds: 5));
  debugPrint("After Delay");

  return true;
}

@riverpod
Future<bool> tindeqConnected(TindeqConnectedRef ref) async {
  // final connected = await tindeq();
  bool connected = false;
  debugPrint("Before Delay");

  await Future.delayed(const Duration(seconds: 5));
  debugPrint("After Delay");

  connected = true;
  return connected;
}
