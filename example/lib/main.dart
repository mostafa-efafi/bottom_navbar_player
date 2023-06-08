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

    const titleStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17);
    final boxDecoration = BoxDecoration(
        color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bottom NavBar Player'),
        ),
        body: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// [video Player] container
            Container(
              padding: const EdgeInsets.all(25),
              decoration: boxDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Video Player',
                    style: titleStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// For when the [video] is played over the http URL [sourceType: SourceType.url]
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () => bottomNavBarPlayer.play(
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                        sourceType: SourceType.url,
                        playerSize: PlayerSize.max,
                        mediaType: MediaType.video),
                    child: const Text('from URL'),
                  ),

                  /// For when the [video] is played over the asset path [sourceType: SourceType.asset]
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () => bottomNavBarPlayer.play('assets/bee.mp4',
                        sourceType: SourceType.asset,
                        playerSize: PlayerSize.max,
                        mediaType: MediaType.video),
                    child: const Text('from Asset'),
                  ),

                  /// For when the [video] is played through the file stored in the memory [sourceType: SourceType.file]
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () => bottomNavBarPlayer.play(
                        '/storage/sdcard/Download/bee.mp4',
                        sourceType: SourceType.file,
                        playerSize: PlayerSize.max,
                        mediaType: MediaType.video),
                    child: const Text('from File'),
                  ),

                  /// For when the [video] is played through the file with [PlayerSize.min]
                  MaterialButton(
                    color: Colors.orange.shade200,
                    onPressed: () => bottomNavBarPlayer.play('assets/bee.mp4',
                        sourceType: SourceType.asset,
                        playerSize: PlayerSize.min,
                        mediaType: MediaType.video),
                    child: const Text('Min Size'),
                  ),
                ],
              ),
            ),

            /// [Audio Player] container
            Container(
              padding: const EdgeInsets.all(25),
              decoration: boxDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Audio Player',
                    style: titleStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// For when the [audio] is played over the http URL [sourceType: SourceType.url]
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () => bottomNavBarPlayer.play(
                        'https://download.samplelib.com/mp3/sample-9s.mp3',
                        sourceType: SourceType.url,
                        playerSize: PlayerSize.max,
                        mediaType: MediaType.audio),
                    child: const Text('from URL'),
                  ),

                  /// For when the [audio] is played over the asset path [sourceType: SourceType.asset]
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () => bottomNavBarPlayer.play('assets/audio.mp3',
                        sourceType: SourceType.asset,
                        playerSize: PlayerSize.max,
                        mediaType: MediaType.audio),
                    child: const Text('from Asset'),
                  ),

                  /// For when the [audio] is played through the file stored in the memory [sourceType: SourceType.file]
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () => bottomNavBarPlayer.play(
                        '/storage/sdcard/Download/audio_file.mp3',
                        sourceType: SourceType.file,
                        playerSize: PlayerSize.max,
                        mediaType: MediaType.audio),
                    child: const Text('from File'),
                  ),

                  /// For when the [audio] is played through the file stored with
                  MaterialButton(
                    color: Colors.orange.shade200,
                    onPressed: () => bottomNavBarPlayer.play('assets/audio.mp3',
                        sourceType: SourceType.asset,
                        playerSize: PlayerSize.min,
                        mediaType: MediaType.audio),
                    child: const Text('Min Size'),
                  ),
                ],
              ),
            ),
          ],
        )),

        ///Set the player widget for [bottomNavigationBar] or [bottomSheet] scaffold
        bottomSheet: bottomNavBarPlayer.view(),
      ),
    );
  }
}
