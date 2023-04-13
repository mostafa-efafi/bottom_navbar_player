// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last

import 'package:bottom_navbar_player/bottom_navbar_player.dart';
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
    final videoContainerSize = MediaQuery.of(context).size.height * 0.44;
    return Container(
      /// widget container [size],
      height:
          widget.bloc.mediaType == MediaType.audio ? 110 : videoContainerSize,
      color: Colors.grey[900],
      child: widget.bloc.mediaType == MediaType.video

          /// [video player] UI when mediaType is [MediaType.video]
          ? VideoPlayerWidget(
              bloc: widget.bloc, progressBarState: widget.progressBarState)

          /// [audio player] UI when mediaType is [MediaType.audio]
          : AudioPlayerWidget(
              bloc: widget.bloc, progressBarState: widget.progressBarState),
    );
  }
}
