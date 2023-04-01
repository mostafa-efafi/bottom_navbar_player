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
    /// create an instance of the class
    final bottomNavBarPlayer = BottomNavBarPlayer();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bottom NavBar Player'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// For when the sound is played over the http URL [sourceType: SourceType.url]
            MaterialButton(
              onPressed: () => bottomNavBarPlayer.play(
                  'https://download.samplelib.com/mp3/sample-9s.mp3',
                  sourceType: SourceType.url),
              child: const Text('play from URL'),
            ),

            /// For when the sound is played over the asset path [sourceType: SourceType.asset]
            MaterialButton(
              onPressed: () => bottomNavBarPlayer.play('assets/audio.mp3',
                  sourceType: SourceType.asset),
              child: const Text('play from Asset'),
            ),

            /// For when the sound is played through the file stored in the memory [sourceType: SourceType.file]
            MaterialButton(
              onPressed: () => bottomNavBarPlayer.play(
                  '/storage/sdcard/Download/audio_file.mp3',
                  sourceType: SourceType.file),
              child: const Text('play from File'),
            ),
          ],
        )),

        ///Set the player widget for [bottomNavigationBar] or [bottomSheet] scaffold
        bottomSheet: bottomNavBarPlayer.view(),
      ),
    );
  }
}
