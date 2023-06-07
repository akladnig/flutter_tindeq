import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tindeq_provider.g.dart';

@riverpod
Future<bool> tindeqConnected(TindeqConnectedRef ref) async {
  // final connected = await tindeq();
  bool connected = false;
  await Future.delayed(const Duration(seconds: 1));

  connected = true;
  return connected;
}
