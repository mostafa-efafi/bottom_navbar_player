import 'package:bottom_navbar_player/src/progress_bar_state.dart';
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
    if (widget.state == ButtonState.paused) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return AnimatedIcon(
      icon: AnimatedIcons.pause_play,
      progress: animation,
    );
  }
}
