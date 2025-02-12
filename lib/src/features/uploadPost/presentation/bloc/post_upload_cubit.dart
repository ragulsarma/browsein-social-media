import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/core/network/network_info.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/data/post_model.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/persistence/post_dao.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart';
import 'package:uuid/uuid.dart';

part 'post_upload_state.dart';

@injectable
class PostUploadCubit extends Cubit<PostUploadState> {
  PostUploadCubit() : super(PostUploadInitial());

  final postDAO = getIt<PostDAO>();
  final _fireStore = getIt<FirebaseFirestore>();
  final _firebaseAuthDi = getIt<FirebaseAuth>();
  final NetworkInfoImpl _networkInfo = NetworkInfoImpl();

  Future<void> uploadPost(
      String description, String imagePath, BuildContext context) async {
    emit(PostUploading());

    try {
      User? user = _firebaseAuthDi.currentUser;
      if (user == null) {
        emit(const PostUploadError("Please login to continue..!"));
        return;
      }

      // Generating unique id for post
      String postId = const Uuid().v1();
      String? photoUrl;

      if (await _networkInfo.isConnected()) {
        // Upload image only when the path is available. since image is optional field.
        if (imagePath.isNotEmpty) {
          photoUrl = await _uploadImageToStorage(imagePath);
        }

        PostModel newPost = PostModel(
            description: description,
            email: user.email ?? '',
            uid: user.uid,
            username: user.displayName ?? "Unknown",
            likes: [],
            id: '',
            postId: postId,
            datePublished: DateTime.now(),
            postUrl: imagePath,
            isPending: false);

        String res = await _uploadPostToFirebaseDb(newPost, photoUrl ?? '');

        if (res == "success") {
          emit(PostUploadSuccess());
        } else {
          emit(PostUploadError(res));
        }
      } else {
        // Store post in Hive for offline sync
        PostModel pendingPost = PostModel(
          description: description,
          email: user.email ?? '',
          uid: user.uid,
          username: user.displayName ?? "Unknown",
          likes: [],
          id: '',
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: imagePath,
          isPending: true, // Mark as pending sync
        );

        postDAO.database.box.put(postId, pendingPost);

        // Notify PostsCubit about the new offline post
        BlocProvider.of<PostsCubit>(context).fetchPosts();

        emit(PostUploadSuccess());
      }
    } catch (e) {
      debugPrint('Error..${e.toString()}');
      emit(PostUploadError(e.toString()));
    }
  }

  // Method to sync offline posts to Firebase when connection is available
  Future<void> syncPendingPosts() async {
    User? user = _firebaseAuthDi.currentUser;
    if (user == null) return;

    // Filter pending items based on isPending flag
    List<PostModel> pendingPosts =
        postDAO.database.box.values.where((post) => post.isPending).toList();

    for (var post in pendingPosts) {
      try {
        String? photoUrl;

        if (post.postUrl.isNotEmpty) {
          photoUrl = await _uploadImageToStorage(post.postUrl);
        }

        String res = await _uploadPostToFirebaseDb(post, photoUrl ?? '');

        if (res == "success") {
          postDAO.database.box
              .delete(post.postId); // Remove from Hive after syncing

          // Fetch latest post from Firebase
          DocumentSnapshot doc =
              await _fireStore.collection('posts').doc(post.postId).get();
          if (doc.exists) {
            PostModel newPost =
                PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            postDAO.database.box
                .put(newPost.postId, newPost); // Save latest post in Hive
          }
        }
      } catch (e) {
        debugPrint('Sync failed for post ${post.postId}: $e');
      }
    }
  }

  Future<String> _uploadPostToFirebaseDb(
      PostModel post, String photoUrl) async {
    String res = "Some error occurred";

    try {
      PostModel postItem = PostModel(
        description: post.description,
        uid: post.uid,
        username: post.username,
        likes: post.likes,
        postId: post.postId,
        datePublished: post.datePublished,
        postUrl: photoUrl,
        isPending: false,
        id: post.id,
        email: post.email,
      );

      await _fireStore
          .collection('posts')
          .doc(post.postId)
          .set(postItem.toMap());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String?> _uploadImageToStorage(String imageFile) async {
    // Using Cloudinary to store images.
    final cloudinary = Cloudinary.unsignedConfig(
      cloudName: 'dmt72o5ya', // cloud name
    );

    final response = await cloudinary.unsignedUpload(
        file: imageFile,
        uploadPreset: 'public_preset',
        resourceType: CloudinaryResourceType.image,
        progressCallback: (count, total) {
          debugPrint('Uploading image progress: $count/$total');
        });

    if (response.isSuccessful) {
      return response.secureUrl;
    }
    return null;
  }
}
