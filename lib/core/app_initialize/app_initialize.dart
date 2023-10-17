import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ym_daa_toce/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AppInitialize {
  static appInitialize() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await SharedPreferences.getInstance();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
