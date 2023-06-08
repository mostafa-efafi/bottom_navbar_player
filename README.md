# Bottom NavBar Player

<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
<a href="https://dart.dev"><img src="https://img.shields.io/badge/dart-website-deepskyblue.svg" alt="Dart Website"></a>
<a href="https://developer.android.com" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Android-deepskyblue">
</a>
<a href="https://developer.apple.com/ios/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-iOS-deepskyblue">
</a>

A Flutter plugin to play audio and video in BottomNavigationBar and bottomSheet with `file`, `web` and `asset` playback capabilities.
Simply play `Audio` and `Video` in different input methods in the list or anywhere else.

|             | Android | iOS   | Web   |
|-------------|---------|-------|-------|
| **Support** | SDK 16+ | 11.0+ | Any\* |


## Preview
![](demo.gif)

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
To play the `Video` from the `URL` , `Asset` and `File` proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play(
                        /// [url]
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                        ///  [Assest] 'assets/bee.mp4' ,
                        /// [File] '/storage/sdcard/Download/bee.mp4' ,
                        sourceType: SourceType.url,///or  [assest] SourceType.asset ,[File] SourceType.file
                        playerSize: PlayerSize.max, ///or [min] PlayerSize.min
                        mediaType: MediaType.video,
                         ),
                    child: const Text('from URL'),
                  ),
```

#### Audio player
To play the `Audio` from the `URL` , `Asset` and `File` proceed as follows:
```dart
MaterialButton(
                    onPressed: () => bottomNavBarPlayer.play(
                      /// [url]
                        'https://download.samplelib.com/mp3/sample-9s.mp3',
                      ///  [Assest] 'assets/audio.mp3' ,
                      /// [File] '/storage/sdcard/Download/audio_file.mp3' ,
                        sourceType: SourceType.url,///or [Assest] SourceType.asset ,[File] SourceType.file
                        playerSize: PlayerSize.max, ///or [min] PlayerSize.min
                        mediaType: MediaType.audio
                        ),
                    child: const Text('from URL'),
                  )
```


### Permissions and configuration

#### Android
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
If you wish to connect to non-HTTPS URLS, or if you use a feature that depends on the proxy such as headers, caching or stream audio sources, also add the following attribute to the `application` element:
```xml
<application ... android:usesCleartextTraffic="true">
```
#### iOS

If you wish to connect to non-HTTPS URLS, or if you use a feature that depends on the proxy such as headers, caching or stream audio sources, add the following to your `Info.plist` file:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```


### License
MIT

### About
Built with <3   
by Mostafa Efafi  
