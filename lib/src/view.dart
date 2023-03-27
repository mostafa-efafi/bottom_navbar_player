// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last

import 'package:bottom_navbar_player/src/progress_bar_state.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class View extends StatefulWidget {
  final Bloc bloc;
  final ProgressBarState progressBarState;
  const View({
    Key? key,
    required this.progressBarState,
    required this.bloc,
  }) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      color: Colors.grey[900],
      child: Column(
        children: [_sliderContainer(), _controllerButtons()],
      ),
    );
  }

  Widget _sliderContainer() {
    const textStyle = TextStyle(fontSize: 10, color: Colors.white);
    return ValueListenableBuilder<ProgressBarState>(
        valueListenable: widget.bloc.progressNotifier,
        builder: (context, value, _) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                Slider.adaptive(
                  value: widget.bloc.sliderDoubleConvertor(
                      position: value.current, audioDuration: value.total),
                  onChanged: (inChangeVal) =>
                      widget.bloc.seek(value.total * inChangeVal),
                  thumbColor: Colors.white,
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey[600],
                  divisions: 500,
                  label: _makeStandardValueLable('${value.current}'),
                ),
                Positioned(
                    bottom: 0,
                    left: 8,
                    child: Text(
                        _makeStandardValueLable(value.current.toString()),
                        style: textStyle)),
                Positioned(
                    bottom: 0,
                    right: 8,
                    child: Text(_makeStandardValueLable(value.total.toString()),
                        style: textStyle))
              ],
            ),
          );
        });
  }

  Widget _controllerButtons() {
    return Row(
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
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
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
          child: const Icon(
            Icons.replay_5_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.white12,
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
          onPressed: () => widget.bloc.moveFor5Second(isForward: true),
          elevation: 0,
          heroTag: null,
          mini: true,
          child: const Icon(
            Icons.forward_5_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.white12,
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
            child: const Icon(
              Icons.stop_rounded,
              size: 20,
              color: Colors.white,
            ),
            backgroundColor: Colors.white12,
          ),
        ),
      ],
    );
  }

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
        return widget.bloc.play;
      case ButtonState.stoped:
        return widget.bloc.play;
      case ButtonState.paused:
        return widget.bloc.pause;
      case ButtonState.playing:
        return widget.bloc.pause;
    }
  }
}
