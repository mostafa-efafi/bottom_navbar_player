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
    const textStyle = TextStyle(fontSize: 10, color: Colors.white);
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
                    Text(Tools.makeStandardValueLable(value.current.toString()),
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

                    /// [value.total]
                    Text(Tools.makeStandardValueLable(value.total.toString()),
                        style: textStyle)
                  ],
                ),
              ),
            ),
          );
        });
  }
}
