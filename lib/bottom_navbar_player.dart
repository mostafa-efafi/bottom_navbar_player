
import 'bottom_navbar_player_platform_interface.dart';

class BottomNavbarPlayer {
  Future<String?> getPlatformVersion() {
    return BottomNavbarPlayerPlatform.instance.getPlatformVersion();
  }
}
