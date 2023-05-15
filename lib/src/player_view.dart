// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last

import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/widgets/player_ui/audio_player_widget.dart';
import 'package:bottom_navbar_player/src/widgets/player_ui/video_player_widget.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class PlayerView extends StatefulWidget {
  final Bloc bloc;
  final ProgressBarState progressBarState;
  const PlayerView({
    Key? key,
    required this.progressBarState,
    required this.bloc,
  }) : super(key: key);

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late Animation animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.bloc.mediaType == MediaType.video

        /// [video player] UI when mediaType is [MediaType.video]
        ? VideoPlayerWidget(
            bloc: widget.bloc, progressBarState: widget.progressBarState)

        /// [audio player] UI when mediaType is [MediaType.audio]
        : AudioPlayerWidget(
            bloc: widget.bloc, progressBarState: widget.progressBarState);
  }
}
