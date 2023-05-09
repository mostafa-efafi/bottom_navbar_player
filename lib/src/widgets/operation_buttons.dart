import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/utils/constants.dart';
import 'package:bottom_navbar_player/src/utils/tools.dart';
import 'package:bottom_navbar_player/src/widgets/play_pause_button.dart';
import 'package:flutter/material.dart';

/// All the playback control buttons are designed in this area
class OperationButtons extends StatelessWidget {
  final Bloc bloc;
  const OperationButtons({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        /// Get instant [speedNotifier] information and user interface update
        ValueListenableBuilder<PlaySpeed>(
          valueListenable: bloc.speedNotifier,
          builder: (_, value, __) {
            return SizedBox(
              width: 32,
              height: 32,
              child: FloatingActionButton(
                onPressed: () => bloc.setPlayerSpeed(value == PlaySpeed.play2x
                    ? PlaySpeed.play1x
                    : PlaySpeed.play2x),
                elevation: 0,
                heroTag: null,
                mini: true,
                backgroundColor: Colors.white12,
                child: Text(
                  value == PlaySpeed.play2x ? '1X' : '2X',
                  style: Constants.CONTROLLER_BUTTON_TEXT_STYLE,
                ),
              ),
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),

        /// Play button from [5 seconds ago]
        FloatingActionButton(
          onPressed: () => bloc.moveFor5Second(isForward: false),
          elevation: 0,
          heroTag: null,
          mini: true,
          backgroundColor: Colors.white12,
          child: const Icon(
            Icons.replay_5_rounded,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),

        /// [play] and [pause] button
        ValueListenableBuilder<ButtonState>(
          valueListenable: bloc.buttonNotifier,
          builder: (_, value, __) {
            return FloatingActionButton(
              backgroundColor: Colors.white12,
              elevation: 0,
              heroTag: null,
              onPressed: Tools.onPressPlayButton(value, bloc),

              /// generate icon for [play],[pause] button
              child: PlayPuaseButton(state: value),
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),

        /// Play button from the [next 5 seconds]
        FloatingActionButton(
          onPressed: () => bloc.moveFor5Second(isForward: true),
          elevation: 0,
          heroTag: null,
          mini: true,
          backgroundColor: Colors.white12,
          child: const Icon(
            Icons.forward_5_rounded,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),

        /// [stop] button
        SizedBox(
          width: 32,
          height: 32,
          child: FloatingActionButton(
            onPressed: () => bloc.stop(),
            elevation: 0,
            heroTag: null,
            mini: true,
            backgroundColor: Colors.white12,
            child: const Icon(
              Icons.stop_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
