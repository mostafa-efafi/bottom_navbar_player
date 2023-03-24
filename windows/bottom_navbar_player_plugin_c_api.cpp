#include "include/bottom_navbar_player/bottom_navbar_player_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bottom_navbar_player_plugin.h"

void BottomNavbarPlayerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  bottom_navbar_player::BottomNavbarPlayerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
