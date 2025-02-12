import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_clone_flutter/firebase_options.dart';
import 'package:social_media_clone_flutter/src/app.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/services/hive_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // register all dependencies
  getItInit();

  // initiate Hive service
  await HiveServices.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SocialMediaCloneFlutter());
}
