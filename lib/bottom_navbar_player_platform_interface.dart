import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bottom_navbar_player_method_channel.dart';

abstract class BottomNavbarPlayerPlatform extends PlatformInterface {
  /// Constructs a BottomNavbarPlayerPlatform.
  BottomNavbarPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BottomNavbarPlayerPlatform _instance = MethodChannelBottomNavbarPlayer();

  /// The default instance of [BottomNavbarPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBottomNavbarPlayer].
  static BottomNavbarPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BottomNavbarPlayerPlatform] when
  /// they register themselves.
  static set instance(BottomNavbarPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
