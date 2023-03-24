#ifndef FLUTTER_PLUGIN_BOTTOM_NAVBAR_PLAYER_PLUGIN_H_
#define FLUTTER_PLUGIN_BOTTOM_NAVBAR_PLAYER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace bottom_navbar_player {

class BottomNavbarPlayerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BottomNavbarPlayerPlugin();

  virtual ~BottomNavbarPlayerPlugin();

  // Disallow copy and assign.
  BottomNavbarPlayerPlugin(const BottomNavbarPlayerPlugin&) = delete;
  BottomNavbarPlayerPlugin& operator=(const BottomNavbarPlayerPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace bottom_navbar_player

#endif  // FLUTTER_PLUGIN_BOTTOM_NAVBAR_PLAYER_PLUGIN_H_
