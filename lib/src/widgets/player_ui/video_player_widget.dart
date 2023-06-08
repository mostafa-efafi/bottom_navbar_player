import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/utils/constants.dart';
import 'package:bottom_navbar_player/src/widgets/operation_buttons.dart';
import 'package:bottom_navbar_player/src/widgets/slider_container.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../bottom_navbar_player.dart';

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
            valueListenable: bloc.playerSizeNotifier,
            builder: (BuildContext _, videoScreenModeValue, Widget? __) {
              return Container(
                color: Constants.PLAYER_BACKGROUND_COLOR,
                height: videoScreenModeValue == PlayerSize.min
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
                                  height: videoScreenModeValue == PlayerSize.min
                                      ? kToolbarHeight
                                      : 0,
                                )
                              ],
                            ),

                            /// [close] and [Maximize] button
                            _closeAndMaximizeButton(),

                            /// [SliderContainer] and [OperationButtons]
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SliderContainer(bloc: bloc),
                                OperationButtons(
                                  bloc: bloc,
                                  mediaType: MediaType.video,
                                )
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

  /// To [close] and  [Maximize] the video player widget with [stop] method
  Widget _closeAndMaximizeButton() {
    return Positioned(
        right: 10,
        top: 10,
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              ValueListenableBuilder(
                valueListenable: bloc.playerSizeNotifier,
                builder: (_, PlayerSize value, __) {
                  return FloatingActionButton(
                    onPressed: () => bloc.videoScreenModeSwitcher(),
                    backgroundColor: Colors.black12,
                    elevation: 0,
                    mini: true,
                    heroTag: null,
                    child: Icon(
                      value == PlayerSize.min
                          ? Icons.fullscreen_rounded
                          : Icons.fullscreen_exit_rounded,
                      color: Colors.white,
                    ),
                  );
                },
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
}
