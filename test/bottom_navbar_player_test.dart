import 'package:flutter_test/flutter_test.dart';
import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:bottom_navbar_player/bottom_navbar_player_platform_interface.dart';
import 'package:bottom_navbar_player/bottom_navbar_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBottomNavbarPlayerPlatform
    with MockPlatformInterfaceMixin
    implements BottomNavbarPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BottomNavbarPlayerPlatform initialPlatform = BottomNavbarPlayerPlatform.instance;

  test('$MethodChannelBottomNavbarPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBottomNavbarPlayer>());
  });

  test('getPlatformVersion', () async {
    BottomNavbarPlayer bottomNavbarPlayerPlugin = BottomNavbarPlayer();
    MockBottomNavbarPlayerPlatform fakePlatform = MockBottomNavbarPlayerPlatform();
    BottomNavbarPlayerPlatform.instance = fakePlatform;

    expect(await bottomNavbarPlayerPlugin.getPlatformVersion(), '42');
  });
}
