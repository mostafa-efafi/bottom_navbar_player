import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/utils/constants.dart';
import 'package:bottom_navbar_player/src/widgets/play_pause_button.dart';
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
            children: [
              /// if [ButtonState] is [error] The [_errorWidget] is displayed else [_sliderContainer]
              value == ButtonState.error ? _errorWidget() : _sliderContainer(),
              _controllerButtons()
            ],
          );
        },
      ),
    );
  }

  /// Slider widget to change the duration of the media
  Widget _sliderContainer() {
    return ValueListenableBuilder<ProgressBarState>(

        /// for [progress] value
        valueListenable: bloc.progressNotifier,
        builder: (context, value, _) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                      trackHeight: 7,
                      overlayColor: Constants.SLIDER_OVERLAY_COLER,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 7),
                      valueIndicatorColor:
                          Constants.SLIDER_VALUE_INDICATORCOLOR),
                  child: Slider.adaptive(
                    value: bloc.sliderDoubleConvertor(
                        position: value.current, audioDuration: value.total),
                    onChanged: (inChangeVal) =>
                        bloc.seek(value.total * inChangeVal),
                    thumbColor: Constants.SLIDER_THUMB_COLOR,
                    activeColor: Constants.SLIDER_OVERLAY_COLER,
                    inactiveColor: Constants.SLIDER_INACTIVE_COLOR,
                    divisions: 200,
                    label: _makeStandardValueLable('${value.current}'),
                  ),
                ),

                /// [value.current]
                Positioned(
                    bottom: 0,
                    left: 8,
                    child: Text(
                        _makeStandardValueLable(value.current.toString()),
                        style: Constants.SLIDER_TEXT_STYLE)),

                /// [value.total]
                Positioned(
                    bottom: 0,
                    right: 8,
                    child: Text(_makeStandardValueLable(value.total.toString()),
                        style: Constants.SLIDER_TEXT_STYLE))
              ],
            ),
          );
        });
  }

  /// All the playback control buttons are designed in this area
  Widget _controllerButtons() {
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
              onPressed: onPressPlayButton(value),

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

  /// This widget is displayed when it is [not connected to the Internet]
  Expanded _errorWidget() {
    return const Expanded(
      child: Icon(
        Icons.wifi_off_rounded,
        color: Colors.white,
      ),
    );
  }

  /// make Standard slider lable
  String _makeStandardValueLable(String value) {
    final list = value.split('.');
    return list.first;
  }

  /// generate function for [play],[pause] button
  void Function() onPressPlayButton(ButtonState state) {
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
