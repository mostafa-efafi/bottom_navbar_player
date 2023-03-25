// ignore_for_file: library_private_types_in_public_api

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

  // @override
  // void dispose() {
  //   super.dispose();
  // }

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
                  // onChangeEnd: (value) => _bloc!.onChangeEndSlider(value),
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
                        style: const TextStyle(fontSize: 10))),
                Positioned(
                    bottom: 0,
                    right: 8,
                    child: Text(_makeStandardValueLable(value.total.toString()),
                        style: const TextStyle(fontSize: 10)))
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
        FloatingActionButton(
          onPressed: () => widget.bloc.moveFor5Second(isForward: true),
          elevation: 0,
          heroTag: null,
          mini: true,
          // ignore: sort_child_properties_last
          child: const Icon(
            Icons.forward_5_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.white12,
        ),
        const SizedBox(
          width: 10,
        ),
        ValueListenableBuilder<ButtonState>(
          valueListenable: widget.bloc.buttonNotifier,
          builder: (_, value, __) {
            switch (value) {
              case ButtonState.loading:
                return FloatingActionButton(
                  backgroundColor: Colors.white12,
                  elevation: 0,
                  heroTag: null,
                  child: const CircularProgressIndicator(),
                  onPressed: widget.bloc.play,
                );
              case ButtonState.stoped:
                return FloatingActionButton(
                  backgroundColor: Colors.white12,
                  elevation: 0,
                  heroTag: null,
                  child: const Icon(Icons.play_arrow_rounded),
                  onPressed: widget.bloc.play,
                );
              case ButtonState.paused:
                return FloatingActionButton(
                  backgroundColor: Colors.white12,
                  elevation: 0,
                  heroTag: null,
                  child: const Icon(Icons.play_arrow_rounded),
                  onPressed: widget.bloc.pause,
                );
              case ButtonState.playing:
                return FloatingActionButton(
                  backgroundColor: Colors.white12,
                  elevation: 0,
                  heroTag: null,
                  child: const Icon(Icons.pause_rounded),
                  onPressed: widget.bloc.pause,
                );
            }
          },
        ),
        const SizedBox(
          width: 10,
        ),
        FloatingActionButton(
          onPressed: () => widget.bloc.moveFor5Second(isForward: false),
          elevation: 0,
          heroTag: null,
          mini: true,
          // ignore: sort_child_properties_last
          child: const Icon(
            Icons.replay_5_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.white12,
        )
      ],
    );
  }

  String _makeStandardValueLable(String value) {
    final list = value.split('.');
    return list.first;
  }
}
