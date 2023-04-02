import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/progress_bar_state.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatelessWidget {
  final Bloc bloc;
  final ProgressBarState progressBarState;
  const VideoPlayerWidget(
      {super.key, required this.bloc, required this.progressBarState});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Expanded(
            child: FlutterLogo(
          size: 200,
        )),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [_sliderContainer(), _controllerButtons()],
        ),
      ],
    );
  }

  Widget _sliderContainer() {
    const textStyle = TextStyle(fontSize: 10, color: Colors.white);
    return ValueListenableBuilder<ProgressBarState>(
        valueListenable: bloc.progressNotifier,
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
                    SliderTheme(
                      data: SliderThemeData(
                          trackHeight: 7,
                          overlayColor: Colors.red,
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 7),
                          valueIndicatorColor: Colors.grey.shade800),
                      child: Expanded(
                        child: Slider.adaptive(
                          value: bloc.sliderDoubleConvertor(
                              position: value.current, audioDuration: value.total),
                          onChanged: (inChangeVal) =>
                              bloc.seek(value.total * inChangeVal),
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
                child: playButtonChildGeneratior(value),
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
      ),
    );
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
        return bloc.play;
      case ButtonState.stoped:
        return bloc.play;
      case ButtonState.paused:
        return bloc.pause;
      case ButtonState.playing:
        return bloc.pause;
    }
  }
}
