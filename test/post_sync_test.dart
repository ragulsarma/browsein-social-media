import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/data/post_model.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  group('Post Synchronization', () {
    late MockFirestore mockFirestore;
    late Box<PostModel> mockHiveBox;
    late PostsCubit postCubit;

    setUp(() async {
      mockFirestore = MockFirestore();
      PathProviderPlatform.instance = MockPathProviderPlatform();
      await Hive.initFlutter();
      Hive.registerAdapter(PostModelAdapter());
      mockHiveBox = await Hive.openBox<PostModel>('posts');
      // postCubit = PostsCubit(mockFirestore, mockHiveBox);
    });

    tearDown(() async {
      await mockHiveBox.clear();
    });

    test('Should sync offline posts to Firebase when online', () async {
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
      // await postCubit.syncPendingLikes();

      verify(
          mockFirestore.collection('posts').doc(post.postId).set(post.toMap()));
      expect(mockHiveBox.get(post.postId), isNull);
    });
  });
}
