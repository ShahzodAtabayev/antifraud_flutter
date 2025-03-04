import 'package:antifraud_flutter/antifraud_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      /// Anti Fraud SDK
      final result = await AntifraudFlutter.initialize(host: 'http://172.30.136.12:8080');
      result.fold(
        (f) {},
        (r) {},
      );
      final isInitialized = await AntifraudFlutter.isInitialized();
      isInitialized.fold(
        (f) {},
        (r) {},
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              initPlatformState();
            },
            child: Text('Running on'),
          ),
        ),
      ),
    );
  }
}
