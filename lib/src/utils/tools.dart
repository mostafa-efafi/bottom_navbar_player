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
}
