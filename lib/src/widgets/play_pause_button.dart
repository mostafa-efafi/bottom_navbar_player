import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:flutter/material.dart';

class PlayPuaseButton extends StatefulWidget {
  final ButtonState state;
  const PlayPuaseButton({super.key, required this.state});

  @override
  State<PlayPuaseButton> createState() => _PlayPuaseButtonState();
}

class _PlayPuaseButtonState extends State<PlayPuaseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    /// Initializing the [animation controller]  with a duration of [500] [milliseconds]
    ///  for each animation run
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// For the [stoped] and [paused] state mode, the animation is [forwarded]
    ///  and for the [playing] mode, the animation is [reversed]
    if (widget.state == ButtonState.paused ||
        widget.state == ButtonState.stoped) {
      controller.forward();
    } else if (widget.state == ButtonState.playing) {
      controller.reverse();
    }

    /// For the [loading] state mode, the [CircularProgressIndicator] is displayed
    if (widget.state == ButtonState.loading) {
      return const CircularProgressIndicator();
    } else if (widget.state == ButtonState.error) {
      /// And if there is no connection to the Internet in [error] mode,
      ///  the error icon will be displayed
      return const Icon(Icons.error_outline_rounded);
    } else {
      return AnimatedIcon(
        icon: AnimatedIcons.pause_play,
        progress: animation,
      );
    }
  }
}
