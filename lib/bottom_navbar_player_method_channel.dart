import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bottom_navbar_player_platform_interface.dart';

/// An implementation of [BottomNavbarPlayerPlatform] that uses method channels.
class MethodChannelBottomNavbarPlayer extends BottomNavbarPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bottom_navbar_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
