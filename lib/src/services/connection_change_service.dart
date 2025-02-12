import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart';
import 'package:social_media_clone_flutter/src/features/uploadPost/presentation/bloc/post_upload_cubit.dart';

class ConnectionChangeService {
  static PostsCubit? _postsCubit;
  static PostUploadCubit? _postUploadCubit;

  static void initListen(
      PostsCubit postsCubit, PostUploadCubit postUploadCubit) {
    _postsCubit = postsCubit;
    _postUploadCubit = postUploadCubit;

    Connectivity().onConnectivityChanged.listen((event) {
      if (!event.contains(ConnectivityResult.none)) {
        // Sync only if there are any pending likes
        if (Hive.box<String>(AppStrings.pendingLikes).isNotEmpty) {
          _postsCubit?.syncPendingLikes();
        }

        // Sync only if there are pending posts
        if (_postUploadCubit?.postDAO.database.box.values
                .any((post) => post.isPending) ?? false) {
          _postUploadCubit?.syncPendingPosts();
        }

        // _postsCubit?.syncPendingLikes();
        // _postUploadCubit?.syncPendingPosts();
      }
    });
  }
}
