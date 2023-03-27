// ignore_for_file: library_private_types_in_public_api

import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/progress_bar_state.dart';
import 'package:bottom_navbar_player/src/view.dart';
import 'package:flutter/material.dart';

class BottomNavBarPlayer {
  final _bloc = Bloc();

  /// Use this for [bottomSheet] or [bottomNavigationBar] Scaffold widget so the player will be displayed during playback.
  Widget view() {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: _bloc.progressNotifier,
      builder: (_, progressBarState, __) {
        return ValueListenableBuilder(
            valueListenable: _bloc.buttonNotifier,
            builder: (_, buttonState, __) {
              if (buttonState == ButtonState.stoped) {
                return const SizedBox();
              } else {
                return View(bloc: _bloc, progressBarState: progressBarState);
              }
            });
      },
    );
  }

  /// This function is to start the [playback] operation
  void play(String path, {SourceType? sourceType = SourceType.url}) {
    _bloc.play(inputFilePath: path, sourceType: sourceType!);
  }
}

enum SourceType { asset, file, url }

