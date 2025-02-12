import 'package:injectable/injectable.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/core/persistence/database.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/data/post_model.dart';

@lazySingleton
class PostDAO {
  late Database<PostModel> database;

  PostDAO() {
    database = Database<PostModel>(boxName: AppStrings.postBox);
  }

  final String key = "post";

  Future<void> savePosts(List<PostModel> posts) async {
    await database.box.clear();
    for (var post in posts) {
      await database.box.put(post.id, post);
    }
  }

  Future<List<PostModel>> getPosts() async {
    return database.box.values.toList();
  }
}
