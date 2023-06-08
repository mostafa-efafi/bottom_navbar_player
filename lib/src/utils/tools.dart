import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';

class Tools {
  /// makeStandard slider lable
  static String makeStandardValueLable(String value) {
    final list = value.split('.');
    return list.first;
  }

  /// generate function for [play],[pause] button
  static void Function() onPressPlayButton(ButtonState state, Bloc bloc) {
    switch (state) {
      case ButtonState.loading:
        return bloc.startPlaying;
      case ButtonState.stoped:
        return bloc.startPlaying;
      case ButtonState.paused:
        return bloc.pause;
      case ButtonState.playing:
        return bloc.pause;
      case ButtonState.error:
        return () {};
    }
  }

  /// This method is used to convert the [URL] or [path] of the file
  ///  in storage to the [name] of the file
  static String getFileNameFromPath(String path) {
    try {
      return path.split('/').last;
    } catch (e) {
      return '';
    }
  }

  /// remaining time with [current] and [total] duration
  static Duration getRemainingTime(
      {required Duration current, required Duration total}) {
    try {
      if (total > current) {
        final remTime = total.inMilliseconds - current.inMilliseconds;
        return Duration(milliseconds: remTime);
      } else {
        return Duration.zero;
      }
    } on Exception {
      return Duration.zero;
    }
  }
}
