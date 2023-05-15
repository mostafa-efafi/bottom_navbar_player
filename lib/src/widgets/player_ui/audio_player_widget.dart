import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/utils/constants.dart';
import 'package:bottom_navbar_player/src/widgets/operation_buttons.dart';
import 'package:bottom_navbar_player/src/widgets/slider_container.dart';
import 'package:flutter/material.dart';

/// This widget is designed for the user interface of the [audio player]
class AudioPlayerWidget extends StatelessWidget {
  final Bloc bloc;
  final ProgressBarState progressBarState;
  const AudioPlayerWidget(
      {super.key, required this.bloc, required this.progressBarState});

  @override
  Widget build(BuildContext context) {
    /// Get instant [buttonNotifier] information and user interface update
    return Container(
      color: Constants.PLAYER_BACKGROUND_COLOR,
      height: 110,
      child: ValueListenableBuilder(
        valueListenable: bloc.buttonNotifier,
        builder: (BuildContext _, value, Widget? __) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// if [ButtonState] is [error] The [_errorWidget] is displayed else [_sliderContainer]
              value == ButtonState.error
                  ? _errorWidget()
                  : SliderContainer(
                      bloc: bloc,
                    ),
              OperationButtons(
                bloc: bloc,
                mediaType: MediaType.audio,
              )
            ],
          );
        },
      ),
    );
  }

  /// This widget is displayed when it is [not connected to the Internet]
  Expanded _errorWidget() {
    return const Expanded(
      child: Icon(
        Icons.wifi_off_rounded,
        color: Colors.white,
      ),
    );
  }
}
