import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1049551382567997/8927141206';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1049551382567997/8927141206';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1049551382567997/1303101359';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1049551382567997/1303101359';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
