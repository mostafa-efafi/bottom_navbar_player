import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/progress_bar_state.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Bloc bloc;
  final ProgressBarState progressBarState;
  const VideoPlayerWidget(
      {super.key, required this.bloc, required this.progressBarState});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late GlobalKey<ScaffoldState> _stateKey;

  @override
  void initState() {
    super.initState();
    _stateKey = GlobalKey<ScaffoldState>();
    widget.bloc.stateKey = _stateKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      key: _stateKey,
      body: FutureBuilder(
          future: widget.bloc.initVideoPlayer(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.bloc.videoPlayerController.value.isInitialized
                          ? Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: widget.bloc.videoPlayerController
                                      .value.aspectRatio,
                                  child: VideoPlayer(
                                      widget.bloc.videoPlayerController),
                                ),
                                _closeButton(),
                              ],
                            )
                          : Container(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [_sliderContainer(), _controllerButtons()],
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _sliderContainer() {
    const textStyle = TextStyle(fontSize: 10, color: Colors.white);
    return ValueListenableBuilder<ProgressBarState>(
        valueListenable: widget.bloc.progressNotifier,
        builder: (context, value, _) {
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
                          overlayColor: Colors.red,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                          valueIndicatorColor: Colors.grey.shade800),
                      child: Expanded(
                        child: Slider.adaptive(
                          value: widget.bloc.sliderDoubleConvertor(
                              position: value.current,
                              audioDuration: value.total),
                          onChanged: (inChangeVal) =>
                              widget.bloc.seek(value.total * inChangeVal),
                          thumbColor: Colors.white,
                          activeColor: Colors.red,
                          inactiveColor: Colors.grey[600],
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

  Widget _controllerButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          /// [Play speed] button
          ValueListenableBuilder<PlaySpeed>(
            valueListenable: widget.bloc.speedNotifier,
            builder: (_, value, __) {
              return SizedBox(
                width: 32,
                height: 32,
                child: FloatingActionButton(
                  onPressed: () => widget.bloc.setPlayerSpeed(
                      value == PlaySpeed.play2x
                          ? PlaySpeed.play1x
                          : PlaySpeed.play2x),
                  elevation: 0,
                  heroTag: null,
                  mini: true,
                  backgroundColor: Colors.white12,
                  child: Text(
                    value == PlaySpeed.play2x ? '1X' : '2X',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w900),
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
            onPressed: () => widget.bloc.moveFor5Second(isForward: false),
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
            valueListenable: widget.bloc.buttonNotifier,
            builder: (_, value, __) {
              return FloatingActionButton(
                backgroundColor: Colors.white12,
                mini: true,
                elevation: 0,
                heroTag: null,
                onPressed: () => widget.bloc.videoPlayerController
                    .play() /* onPressPlayButton(value) */,
                child: playButtonChildGeneratior(value),
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),

          /// Play button from the [next 5 seconds]
          FloatingActionButton(
            onPressed: () => widget.bloc.moveFor5Second(isForward: true),
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
              onPressed: () => widget.bloc.stop(),
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
      ),
    );
  }

  Widget _closeButton() {
    return Positioned(
        right: 10,
        top: 10,
        child: SizedBox(
          height: 30,
          width: 30,
          child: FloatingActionButton(
            onPressed: () {
              /// TODO [Add function for close video player]
            },
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
        ));
  }

  /// makeStandard slider lable
  String _makeStandardValueLable(String value) {
    final list = value.split('.');
    return list.first;
  }

  Widget playButtonChildGeneratior(ButtonState state) {
    switch (state) {
      case ButtonState.loading:
        return const CircularProgressIndicator();
      case ButtonState.stoped:
        return const Icon(Icons.play_arrow_rounded);
      case ButtonState.paused:
        return const Icon(Icons.play_arrow_rounded);
      case ButtonState.playing:
        return const Icon(Icons.pause_rounded);
    }
  }

  void Function() onPressPlayButton(ButtonState state) {
    switch (state) {
      case ButtonState.loading:
        return widget.bloc.startPlaying;
      case ButtonState.stoped:
        return widget.bloc.startPlaying;
      case ButtonState.paused:
        return widget.bloc.pause;
      case ButtonState.playing:
        return widget.bloc.pause;
    }
  }
}
