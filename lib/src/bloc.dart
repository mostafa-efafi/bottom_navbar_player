// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:bottom_navbar_player/src/progress_bar_state.dart';
import 'package:bottom_navbar_player/src/utils/network_checker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class Bloc {
  MediaType? mediaType;
  String? inputFilePath;
  SourceType? sourceType;

  /// To check internet connectivity when the input [sourceType] is a [URL]
  final NetworkChecker _networkChecker = NetworkChecker();
  late SourceType? _lastSourceType;
  late AudioPlayer audioPlayer;
  late VideoPlayerController videoPlayerController;

  /// used [singleton] design pattern
  static final _bloc = Bloc._initFunction();

  Bloc._initFunction();

  factory Bloc(
      {MediaType? mediaType,
      GlobalKey<ScaffoldState>? stateKey,
      String? inputFilePath,
      SourceType? sourceType}) {
    _bloc.sourceType = sourceType;
    _bloc.inputFilePath = inputFilePath;
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

  /// for close [Notifier]
  void dispose() {
    /// dispose [media controller] with input [MediaType]
    if (mediaType == MediaType.audio) {
      audioPlayer.dispose();
    } else {
      videoPlayerController.dispose();
    }
    progressNotifier.dispose();
    buttonNotifier.dispose();
    speedNotifier.dispose();
  }

  /// [video] play with 3 type of SourceType
  Future<bool> _initVideoPlayer() async {
    /// It is necessary to check the Internet connection every time the video is played
    final isConnectNetwork = await _networkChecker.checkConnection();

    /// init [ButtonState] is [loading]
    buttonNotifier.value = ButtonState.loading;
    switch (sourceType) {
      /// [sourceType = URL]
      case SourceType.url:
        videoPlayerController = VideoPlayerController.network(inputFilePath!);
        break;

      /// [sourceType = file]
      case SourceType.file:
        videoPlayerController =
            VideoPlayerController.file(File(inputFilePath!));
        break;

      /// [sourceType = asset]
      case SourceType.asset:
        videoPlayerController = VideoPlayerController.asset(inputFilePath!);
        break;
      default:
    }

    /// If the device is [not connected] to the Internet and
    ///  the input source is the [Internet address], initialization for the controller is not done
    if (isConnectNetwork == false && sourceType == SourceType.url) {
      return false;
    } else {
      /// init videoPlayer controller
      await videoPlayerController.initialize();

      /// start videpPlayer [listener]
      videoPlayerController.addListener(_videoPlayerListener);
      return true;
    }
  }

  /// video Listener To synchronize the slider
  _videoPlayerListener() async {
    /// [current position]
    final newPosition = videoPlayerController.value.position;

    /// The [total] duration of the video
    final total = videoPlayerController.value.duration;

    /// Video [buffered] duration
    final buffered = _getVideoBuffered(total);

    progressNotifier.value = ProgressBarState(
        current: newPosition, buffered: buffered, total: total);
  }

  /// Get the [last buffered value]
  Duration _getVideoBuffered(Duration total) {
    int maxBuffering = 0;
    for (DurationRange range in videoPlayerController.value.buffered) {
      final int end = range.end.inMilliseconds;
      if (end > maxBuffering) {
        maxBuffering = end;
      }
    }
    final result = maxBuffering ~/ total.inMilliseconds;
    return Duration(milliseconds: result);
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

  /// public method for start playing media
  startPlaying() async {
    /// If the input media type is [audio], the [audioController] is [initialized],
    ///  otherwise, the [videoController] is [initialized].
    if (mediaType == MediaType.audio) {
      _initAudioPlayer().whenComplete(() async => await _playAudio());
    } else {
      _initVideoPlayer().then((value) {
        if (value == true) {
          videoPlayerController.play();
          buttonNotifier.value = ButtonState.playing;
        } else {
          buttonNotifier.value = ButtonState.error;
        }
      });
    }
  }

  /// [audio] play with 3 type of SourceType
  Future<void> _playAudio() async {
    final isConnectNetwork = await _networkChecker.checkConnection();

    /// If [sourceType] is not empty, use it, otherwise, use [_lastSourceType]
    if (sourceType != null) {
      _lastSourceType = sourceType;
    }
    sourceType = sourceType ?? _lastSourceType;
    if (isConnectNetwork == false && sourceType == SourceType.url) {
      buttonNotifier.value = ButtonState.error;
    } else {
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
  }

  /// changed play state to [stop]
  void stop() {
    /// If the input media type is [audio], the sound will [stop], otherwise the [video] will [dispose]
    if (mediaType == MediaType.audio) {
      audioPlayer.stop();
    } else {
      videoPlayerController.dispose();
    }
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

  /// To [pause] or [rePlay] the media
  Future<void> pause() async {
    /// If the input media type is [audio], the sound will [pause], otherwise the [video] will [pause]
    if (mediaType == MediaType.audio) {
      await _pauseAudio();
    } else {
      await _pauseVideo();
    }
  }

  /// [pause]  method for VideoPlayer
  Future<void> _pauseVideo() async {
    if (buttonNotifier.value == ButtonState.paused &&
        progressNotifier.value.current != Duration.zero) {
      await videoPlayerController.play();
      buttonNotifier.value = ButtonState.playing;
    } else if (buttonNotifier.value == ButtonState.playing) {
      await videoPlayerController.pause();
      buttonNotifier.value = ButtonState.paused;
    } else {
      buttonNotifier.value = ButtonState.playing;
      await videoPlayerController.play();
    }
  }

  /// [pause]  method for AudioPlayer
  Future<void> _pauseAudio() async {
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

  /// Set [playback speed] (currently 2x)
  Future<void> setPlayerSpeed(PlaySpeed speed) async {
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
    speedNotifier.value = speed;
    if (mediaType == MediaType.audio) {
      await audioPlayer.setSpeed(doubleSpeed);
    } else {
      await videoPlayerController.setPlaybackSpeed(doubleSpeed);
    }
  }

  /// player seek method
  void seek(Duration position) {
    if (mediaType == MediaType.audio) {
      audioPlayer.seek(position);
    } else {
      videoPlayerController.seekTo(position);
    }
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
