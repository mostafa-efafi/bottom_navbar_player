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

enum ButtonState {
  paused,
  playing,
  loading,
  stoped,
}

enum PlaySpeed { play1x, play2x }
