import 'dart:io';

class NetworkChecker {
  static const urlTest = 'google.com';

  /// Return [true] if the device was connected to the Internet, otherwise [false]
  /// It is sent to [Google] [Ping] and the result is returned
  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup(urlTest);
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
