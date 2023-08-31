import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/6300978111'; //Test
      return 'ca-app-pub-1699320212540818/5546253064'; //Real
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; //Test
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/1033173712"; //Test
      return "ca-app-pub-1699320212540818/9348307838"; //Real
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910"; //Test
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/5224354917"; //Test
      return "ca-app-pub-1699320212540818/1431393016"; //Test
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313"; //Test
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
