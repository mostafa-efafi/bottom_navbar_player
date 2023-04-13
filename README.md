## Bottom NavBar Player
A Flutter plugin to play media in BottomNavigationBar and bottomSheet with `file`, `web` and `asset` playback capabilities.
Simply play sounds in different input methods in the list or anywhere else.

<p align="left">
    <img src="demo_audio_player.gif" alt="preview" width="315"/>
    <img src="demo_video_player.gif" alt="preview" width="315"/>
</p>

### Getting Started
In order to use this package, do import
```dart
import 'package:bottom_navbar_player/bottom_navbar_player.dart';
```
First, create an instance of the class:
```dart
final bottomNavBarPlayer = BottomNavBarPlayer();
```

Set the player widget for `BottomNavigationBar` or `bottomSheet` scaffold:
```dart
Scaffold(
        bottomSheet: bottomNavBarPlayer.view(),
      ),
```   

#### Video player
To play the `video` from the `URL`, proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play(
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                        sourceType: SourceType.url,
                        mediaType: MediaType.video),
                    child: const Text('from URL'),
                  ),
```

To play the `video` from the `Asset`, proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play('assets/bee.mp4',
                        sourceType: SourceType.asset,
                        mediaType: MediaType.video),
                    child: const Text('from Asset'),
                  ),
```

To play the `video` from the `File`, proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play(
                        '/storage/sdcard/Download/bee.mp4',
                        sourceType: SourceType.file,
                        mediaType: MediaType.video),
                    child: const Text('from File'),
                  ),
```


#### Audio player
To play the `sound` from the `URL`, proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play(
                        'https://download.samplelib.com/mp3/sample-9s.mp3',
                        sourceType: SourceType.url,
                        mediaType: MediaType.audio),
                    child: const Text('from URL'),
                  )
```

To play the `sound` from the `Asset`, proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play('assets/audio.mp3',
                        sourceType: SourceType.asset,
                        mediaType: MediaType.audio),
                    child: const Text('from Asset'),
                  ),
```

To play the `sound` from the `File`, proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play(
                        '/storage/sdcard/Download/audio_file.mp3',
                        sourceType: SourceType.file,
                        mediaType: MediaType.audio),
                    child: const Text('from File'),
                  ),
```


### Permissions

If you use an internet URL:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

If you use the File:
```xml
<uses-permission android:name="android.permission.READ_INTERNAL_STORAGE"/>
<!-- or -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```



### License
MIT

### About
Built with <3   
by Mostafa Efafi  
