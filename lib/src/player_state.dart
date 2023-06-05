/// setted with [progressNotifier]
class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

/// setted with [buttonNotifier]
enum ButtonState { paused, playing, loading, stoped, error }

/// setted with [speedNotifier]
enum PlaySpeed { play1x, play2x }

