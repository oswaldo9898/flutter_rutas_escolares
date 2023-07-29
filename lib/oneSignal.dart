import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart';

void oneSignalInitialize() {
  if(kDebugMode){
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  }
  OneSignal.shared.setAppId("3eb65a4a-7d1f-4837-bf8c-ac8e251c1c5d");
}