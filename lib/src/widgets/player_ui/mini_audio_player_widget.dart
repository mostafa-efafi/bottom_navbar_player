import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/utils/constants.dart';
import 'package:bottom_navbar_player/src/utils/tools.dart';
import 'package:bottom_navbar_player/src/widgets/slider_container.dart';
import 'package:flutter/material.dart';

/// This widget is designed for the user interface of the [mini] [audio player]
class MiniAudioPlayerWidget extends StatelessWidget {
  final Bloc bloc;
  final ProgressBarState progressBarState;
  const MiniAudioPlayerWidget({
    super.key,
    required this.bloc,
    required this.progressBarState,
  });

  @override
  Widget build(BuildContext context) {
    /// Get instant [buttonNotifier] information and user interface update
    return ValueListenableBuilder<ButtonState>(
        valueListenable: bloc.buttonNotifier,
        builder: (_, buttonStateValue, __) {
          final showPlayer =
              buttonStateValue != ButtonState.stoped ? true : false;
          return AnimatedContainer(
            color: Constants.PLAYER_BACKGROUND_COLOR,
            height: showPlayer ? 40 : 0,
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    /// [opration] [button]
                    _playButton(bloc, context),
                    const SizedBox(
                      width: 7,
                    ),

                    /// show file name
                    _fileNameContainer(bloc),
                  ],
                ),

                /// [slider]
                showPlayer
                    ? Expanded(child: SliderContainer(bloc: bloc))
                    : const SizedBox(),
                _closeBtn(bloc),
              ],
            ),
          );
        });
  }
}

/// convert file [path] or [url] to [file name]
SizedBox _fileNameContainer(Bloc bloc) {
  return SizedBox(
    width: 50,
    child: Center(
      child: Text(
        Tools.getFileNameFromPath(bloc.inputFilePath!),
        overflow: TextOverflow.fade,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    ),
  );
}

InkWell _closeBtn(Bloc bloc) {
  return InkWell(
    onTap: bloc.stop,
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Icon(
        Icons.close,
        size: 20,
        color: Colors.white38,
      ),
    ),
  );
}

/// button for show [paly],[loading],[paused],[error] state
Widget _playButton(Bloc bloc, BuildContext context) {
  final iconColor = Theme.of(context).primaryColor;
  return Padding(
    padding: const EdgeInsets.only(left: 7),
    child: ValueListenableBuilder<ButtonState>(
      valueListenable: bloc.buttonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return InkWell(
              onTap: () {},
              child: Icon(
                Icons.circle_outlined,
                color: iconColor,
              ),
            );
          case ButtonState.stoped:
            return InkWell(
              onTap: Tools.onPressPlayButton(value, bloc),
              child: Icon(
                Icons.play_arrow_rounded,
                color: iconColor,
              ),
            );
          case ButtonState.paused:
            return InkWell(
              onTap: bloc.pause,
              child: Icon(
                Icons.play_arrow_rounded,
                color: iconColor,
              ),
            );
          case ButtonState.playing:
            return InkWell(
              onTap: bloc.pause,
              child: Icon(
                Icons.pause_rounded,
                color: iconColor,
              ),
            );

          /// if [ButtonState] is [error]
          case ButtonState.error:
            return InkWell(
              onTap: () {},
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
              ),
            );
        }
      },
    ),
  );
}
