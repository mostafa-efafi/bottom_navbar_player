import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:bottom_navbar_player/src/bloc.dart';
import 'package:bottom_navbar_player/src/player_state.dart';
import 'package:bottom_navbar_player/src/utils/constants.dart';
import 'package:bottom_navbar_player/src/utils/tools.dart';
import 'package:flutter/material.dart';

/// Slider widget to change the duration of the media
class SliderContainer extends StatelessWidget {
  final Bloc bloc;
  const SliderContainer({super.key, required this.bloc});
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 10, color: Colors.white54);
    return ValueListenableBuilder<ProgressBarState>(
        valueListenable: bloc.progressNotifier,
        builder: (BuildContext _, value, Widget? __) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// [value.current]
                    bloc.playerSize == PlayerSize.min &&
                            bloc.mediaType == MediaType.audio
                        ? const SizedBox()
                        : Text(
                            Tools.makeStandardValueLable(
                                value.current.toString()),
                            style: textStyle),

                    /// [Slider]
                    SliderTheme(
                      data: SliderThemeData(
                          trackHeight: 7,
                          overlayColor: Constants.SLIDER_OVERLAY_COLER,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                          valueIndicatorColor: Colors.grey.shade800),
                      child: Expanded(
                        child: Slider.adaptive(
                          value: bloc.sliderDoubleConvertor(
                              position: value.current,
                              audioDuration: value.total),
                          onChanged: (inChangeVal) =>
                              bloc.seek(value.total * inChangeVal),
                          thumbColor: Constants.SLIDER_THUMB_COLOR,
                          activeColor: Constants.SLIDER_OVERLAY_COLER,
                          inactiveColor: Constants.SLIDER_INACTIVE_COLOR,
                          divisions: 200,
                          label:
                              Tools.makeStandardValueLable('${value.current}'),
                        ),
                      ),
                    ),

                    /// [value.total] show when [!] [mini] [audioPlayer]
                    bloc.playerSize == PlayerSize.min &&
                            bloc.mediaType == MediaType.audio
                        ? _remainingContainer(value, textStyle)
                        : Text(
                            Tools.makeStandardValueLable(
                                value.total.toString()),
                            style: textStyle)
                  ],
                ),
              ),
            ),
          );
        });
  }

  SizedBox _remainingContainer(
      ProgressBarState progressBarValue, TextStyle textStyle) {
    return SizedBox(
      width: 35,
      child: Center(
        child: Text(
          Tools.makeStandardValueLable(
              '${Tools.getRemainingTime(current: progressBarValue.current, total: progressBarValue.total)}'),
          style: textStyle,
        ),
      ),
    );
  }
}
