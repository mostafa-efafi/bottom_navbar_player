// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last

import 'package:bottom_navbar_player/src/progress_bar_state.dart';
import 'package:bottom_navbar_player/src/widgets/audio_player_widget.dart';
import 'package:bottom_navbar_player/src/widgets/video_player_widget.dart';
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

class _ViewState extends State<View> {
  late Animation animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /// for normal [audioPlayer] [110],
      height:300,
      color: Colors.grey[900],
      child: VideoPlayerWidget(
          bloc: widget.bloc,
          progressBarState: widget
              .progressBarState)
          /* AudioPlayerWidget(
              bloc: widget.bloc, progressBarState: widget.progressBarState) */,
    );
  }
}
