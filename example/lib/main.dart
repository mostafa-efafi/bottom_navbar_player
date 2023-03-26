import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBarPlayer = BottomNavBarPlayer();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () => bottomNavBarPlayer
                  .play('https://download.samplelib.com/mp3/sample-9s.mp3'),
              child: const Text('play Audio 1'),
            ),
            MaterialButton(
              onPressed: () => bottomNavBarPlayer
                  .play('https://download.samplelib.com/mp3/sample-12s.mp3'),
              child: const Text('play Audio 2'),
            ),
            MaterialButton(
              onPressed: () => bottomNavBarPlayer
                  .play('https://download.samplelib.com/mp3/sample-15s.mp3'),
              child: const Text('play Audio 3'),
            ),
          ],
        )),
        bottomSheet: bottomNavBarPlayer.view(),
      ),
    );
  }
}
