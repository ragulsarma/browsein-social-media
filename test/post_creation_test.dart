import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/data/post_model.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Post Creation', () {
    late Box<PostModel> mockHiveBox;

    setUpAll(() async {
      PathProviderPlatform.instance =
          MockPathProviderPlatform();
      await Hive.initFlutter();
      Hive.registerAdapter(PostModelAdapter());
      mockHiveBox = await Hive.openBox<PostModel>('posts');
    });

    tearDown(() async {
      await mockHiveBox.clear();
    });

    test('Should save a post in Hive when offline', () async {
      final post = PostModel(
          postId: '123',
          description: 'Test post',
          postUrl: 'offline_image_path.jpg',
          datePublished: DateTime.now(),
          isPending: true,
          id: '',
          email: 'test@gmail.com',
          likes: [],
          uid: '23424422',
          username: 'Test user',
          isLiked: false);

      await mockHiveBox.put(post.postId, post);
      final retrievedPost = mockHiveBox.get(post.postId);

      expect(retrievedPost, isNotNull);
      expect(retrievedPost?.description, 'Test post');
      expect(retrievedPost?.isPending, true);
    });
  });
}
