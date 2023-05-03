import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/utils/constants.dart';
import 'package:bottom_navbar_player/src/widgets/play_pause_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// This widget is designed for the user interface of the [video player]
class VideoPlayerWidget extends StatelessWidget {
  final Bloc bloc;
  final ProgressBarState progressBarState;
  const VideoPlayerWidget(
      {super.key, required this.bloc, required this.progressBarState});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bloc.buttonNotifier,
      builder: (BuildContext _, buttonNotifierValue, Widget? __) {
        final minVideoContainerSize = MediaQuery.of(context).size.height * 0.44;
        final maxVideoContainerSize = MediaQuery.of(context).size.height;
        return ValueListenableBuilder(
            valueListenable: bloc.videoScreenModeNotifier,
            builder: (BuildContext _, videoScreenModeValue, Widget? __) {
              return Container(
                color: Constants.PLAYER_BACKGROUND_COLOR,
                height: videoScreenModeValue == VideoScreenMode.min
                    ? minVideoContainerSize
                    : maxVideoContainerSize,
                width: MediaQuery.of(context).size.width,
                child: Builder(builder: (context) {
                  return buttonNotifierValue == ButtonState.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                !bloc.videoPlayerController.value
                                            .isInitialized ||
                                        buttonNotifierValue == ButtonState.error

                                    /// if [ButtonState] is [error] The [_errorWidget] is displayed else [videoPlayer]
                                    ? _errorWidget()

                                    /// [Video player] Flexibled for any sizes and any aspectRatios
                                    : Flexible(
                                        child: AspectRatio(
                                          aspectRatio: bloc
                                              .videoPlayerController
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(
                                            bloc.videoPlayerController,
                                          ),
                                        ),
                                      ),

                                /// [SizedBox] to display the [_sliderContainer] and [_controllerButtons] more correctly
                                SizedBox(
                                  height: videoScreenModeValue ==
                                          VideoScreenMode.min
                                      ? kToolbarHeight
                                      : 0,
                                )
                              ],
                            ),
                            _closeAndMaximizeButton(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _sliderContainer(),
                                _controllerButtons(),
                              ],
                            ),
                          ],
                        );
                }),
              );
            });
      },
    );
  }

  /// This widget is displayed when it is [not connected to the Internet]
  Expanded _errorWidget() {
    return const Expanded(
        child: Icon(
      Icons.wifi_off_rounded,
      color: Colors.white,
      size: 100,
    ));
  }

  /// Slider widget to change the duration of the media
  Widget _sliderContainer() {
    const textStyle = TextStyle(fontSize: 10, color: Colors.white);
    return ValueListenableBuilder<ProgressBarState>(
        valueListenable: bloc.progressNotifier,
        builder: (BuildContext _, value, Widget? __) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// [value.current]
                    Text(_makeStandardValueLable(value.current.toString()),
                        style: textStyle),

                    /// [Slider]
                    SliderTheme(
                      data: SliderThemeData(
                          trackHeight: 7,
                          overlayColor: Constants.SLIDER_OVERLAY_COLER,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                          valueIndicatorColor: Colors.grey.shade800),
                      child: Expanded(
                        child: Slider.adaptive(
                          value: bloc.sliderDoubleConvertor(
                              position: value.current,
                              audioDuration: value.total),
                          onChanged: (inChangeVal) =>
                              bloc.seek(value.total * inChangeVal),
                          thumbColor: Constants.SLIDER_THUMB_COLOR,
                          activeColor: Constants.SLIDER_OVERLAY_COLER,
                          inactiveColor: Constants.SLIDER_INACTIVE_COLOR,
                          divisions: 200,
                          label: _makeStandardValueLable('${value.current}'),
                        ),
                      ),
                    ),

                    /// [value.total]
                    Text(_makeStandardValueLable(value.total.toString()),
                        style: textStyle)
                  ],
                ),
              ),
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
              mini: true,
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

  /// To [close] and  [Maximize] the video player widget with [stop] method
  Widget _closeAndMaximizeButton() {
    return Positioned(
        right: 10,
        top: 10,
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              FloatingActionButton(
                onPressed: () => bloc.videoScreenModeSwitcher(),
                backgroundColor: Colors.black12,
                elevation: 0,
                mini: true,
                heroTag: null,
                child: const Icon(
                  Icons.fullscreen_rounded,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                onPressed: () => bloc.stop(),
                backgroundColor: Colors.black12,
                elevation: 0,
                mini: true,
                heroTag: null,
                child: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }

  /// makeStandard slider lable
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
