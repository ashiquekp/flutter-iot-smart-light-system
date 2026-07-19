import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisense/app/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LumiSenseApp(),
    ),
  );
}