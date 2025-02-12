import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/core/network/network_info.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/data/post_model.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/persistence/post_dao.dart';

part 'post_state.dart';

@injectable
class PostsCubit extends Cubit<PostsState> {
  final FirebaseFirestore fireStore;
  final _postDAO = getIt<PostDAO>();
  final _firebaseAuthDi = getIt<FirebaseAuth>();
  final NetworkInfoImpl _networkInfo = NetworkInfoImpl();

  PostsCubit(this.fireStore) : super(PostsInitial());

  Future<void> fetchPosts() async {
    emit(PostsLoading());

    // Load from Hive (Offline First)
    final cachedPosts = await _postDAO.getPosts();
    if (cachedPosts.isNotEmpty) {
      cachedPosts.sort((a, b) => b.datePublished.compareTo(a.datePublished)); // Sort in descending order
      emit(PostsLoaded(cachedPosts));
    }

    // Fetch from db and update Hive when internet is available
    fireStore
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .listen(
      (snapshot) async {
        if (await _networkInfo.isConnected()) {
          // Update Hive when online
          final posts = snapshot.docs.map((doc) {
            return PostModel.fromMap(doc.data(), doc.id);
          }).toList();

          // Save to Hive
          await _postDAO.savePosts(posts);
          emit(PostsLoaded(posts));
        }
      },
      onError: (error) {
        emit(PostsError(error.toString()));
      },
    );
  }

  Future<void> likePost(String postId, String uid) async {
    try {
      PostModel? post = _postDAO.database.box.get(postId);

      if (post != null) {
        if (post.likes.contains(uid)) {
          // Unlike post locally
          post.likes.remove(uid);
          post.isLiked = false;
          print('-a-dfda 22');
        } else {
          // Like post locally
          post.likes.add(uid);
          post.isLiked = true;
          print('-a-dfda 33');
        }

        // Save updated post in Hive
        await post.save();

        if (await _networkInfo.isConnected()) {
          // Sync with Firebase when online
          fireStore.collection('posts').doc(postId).update({
            'likes': post.isLiked
                ? FieldValue.arrayUnion([uid])
                : FieldValue.arrayRemove([uid])
          });
        } else {
          // Save the postId in a "pendingLikes" box for later sync
          final pendingBox = Hive.box<String>(AppStrings.pendingLikes);
          pendingBox.put(postId, post.isLiked ? 'like' : 'unlike');
        }
      } else {
        print('-a-dfda ');
      }
    } catch (e) {
      debugPrint('Error ---${e.toString()}');
    }
  }

  void syncPendingLikes() async {
    final pendingBox = Hive.box<String>(AppStrings.pendingLikes);

    if (await _networkInfo.isConnected()) {
      User? user = _firebaseAuthDi.currentUser;

      for (var postId in pendingBox.keys) {
        String action = pendingBox.get(postId) ?? '';
        if (action == 'like') {
          fireStore.collection('posts').doc(postId).update({
            'likes': FieldValue.arrayUnion([user?.uid ?? ''])
          });
        } else if (action == 'unlike') {
          fireStore.collection('posts').doc(postId).update({
            'likes': FieldValue.arrayRemove([user?.uid ?? ''])
          });
        }

        // Remove from pending sync list after successful sync
        pendingBox.delete(postId);
      }
    }
  }
}
