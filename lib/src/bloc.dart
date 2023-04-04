import 'dart:developer';

import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:bottom_navbar_player/src/progress_bar_state.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class Bloc {
  MediaType? mediaType;
  late SourceType? _lastSourceType;
  late AudioPlayer audioPlayer;
  late VideoPlayerController videoPlayerController;

  /// used singleton design pattern
  static final _bloc = Bloc._initFunction();

  Bloc._initFunction();

  factory Bloc({MediaType? mediaType}) {
    _bloc.mediaType = mediaType;
    return _bloc;
  }

  /// [Play button states]
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.stoped);

  /// [Playback speed states]
  final speedNotifier = ValueNotifier<PlaySpeed>(PlaySpeed.play1x);

  /// [Play progress values]
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  void dispose() {
    audioPlayer.dispose();
    progressNotifier.dispose();
    buttonNotifier.dispose();
  }

  Future<void> _initVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    await videoPlayerController
        .initialize(); /* .then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      }); */
  }

  /// Preparing initial values of listeners
  Future<void> _initAudioPlayer() async {
    audioPlayer = AudioPlayer();
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      /// [loading] or [buffering]
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;

        /// [not playing]
      } else if (!isPlaying && buttonNotifier.value == ButtonState.loading) {
        // buttonNotifier.value = ButtonState.stoped;
        buttonNotifier.value = ButtonState.paused;

        /// [stoted]
      } else if (!isPlaying && buttonNotifier.value == ButtonState.stoped) {
        buttonNotifier.value = ButtonState.stoped;

        /// [completed play]
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });

    /// [player position]
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    /// [player buffered Position]
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    /// [player duration]
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  /// play with 3 type of SourceType
  play({String? inputFilePath, SourceType? sourceType}) async {
    if (mediaType == MediaType.audio) {
      _initAudioPlayer().whenComplete(
          () async => await _playAudio(sourceType, inputFilePath));
    } else {
      _initVideoPlayer()
          .whenComplete(() async => await videoPlayerController.play());
      buttonNotifier.value = ButtonState.playing;
      print('playvideo');
    }
  }

  Future<void> _playAudio(SourceType? sourceType, String? inputFilePath) async {
    /// If [sourceType] is not empty, use it, otherwise, use [_lastSourceType]
    if (sourceType != null) {
      _lastSourceType = sourceType;
    }
    sourceType = sourceType ?? _lastSourceType;

    /// Switcher for all play modes
    switch (sourceType) {
      case SourceType.url:
        await audioPlayer.setUrl(inputFilePath!);
        break;
      case SourceType.file:
        audioPlayer.setFilePath(inputFilePath!);
        break;
      case SourceType.asset:
        audioPlayer.setAsset(inputFilePath!);
        break;
      default:
    }
    await audioPlayer.play();
    buttonNotifier.value = ButtonState.playing;
  }

  /// changed play state to [stop]
  void stop() {
    audioPlayer.stop();
    buttonNotifier.value = ButtonState.stoped;
  }

  /// Move playback progress [forward] 5 seconds or [backward] 5 seconds
  Future<void> moveFor5Second({required bool isForward}) async {
    final currentPosition = progressNotifier.value.current.inMilliseconds;
    final total = progressNotifier.value.total.inMilliseconds;
    final move = isForward ? 5000 : -5000; //miliseconds
    int temp = currentPosition + move.toInt();
    if (temp < 0) {
      temp = 0;
    } else if (temp > total) {
      temp = total;
    }
    final position = Duration(milliseconds: temp);
    seek(position);
  }

  /// To [pause] or [rePlay] the sound
  Future<void> pause() async {
    if (buttonNotifier.value == ButtonState.paused &&
        progressNotifier.value.current != Duration.zero) {
      await audioPlayer.play();
      buttonNotifier.value = ButtonState.playing;
    } else if (buttonNotifier.value == ButtonState.playing) {
      await audioPlayer.pause();
      buttonNotifier.value = ButtonState.paused;
    } else {
      buttonNotifier.value = ButtonState.playing;
      await audioPlayer.play();
    }
  }

  Future<void> setPlayerSpeed(PlaySpeed speed) async {
    /// Set [playback speed] (currently 2x)
    double doubleSpeed = 1.0;
    switch (speed) {
      case PlaySpeed.play1x:
        doubleSpeed = 1.0;
        break;
      case PlaySpeed.play2x:
        doubleSpeed = 2.0;
        break;
      default:
    }
    await audioPlayer.setSpeed(doubleSpeed);
    speedNotifier.value = speed;
  }

  /// player seek method
  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  /// To display the [slider] value correctly
  double sliderDoubleConvertor(
      {required Duration position, required Duration audioDuration}) {
    if (audioDuration.inMilliseconds != 0) {
      final res = (position.inMilliseconds) / (audioDuration.inMilliseconds);
      return res;
    } else {
      return 0;
    }
  }
}
