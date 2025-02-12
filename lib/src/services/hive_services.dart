import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/data/post_model.dart';

class HiveServices {

  // add all hive
  static Future<void> init() async {
    // register hive
    final appDocumentDirectory = await getApplicationSupportDirectory();

    await Hive.initFlutter(appDocumentDirectory.path);

    //register adapters
    Hive.registerAdapter(PostModelAdapter());

    //open boxes
    await Hive.openBox<PostModel>(AppStrings.postBox);
    await Hive.openBox<String>(AppStrings.pendingLikes);
  }
}
