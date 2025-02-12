import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/constants/asset_paths.dart';
import 'package:social_media_clone_flutter/src/core/presentation/animations/like_animation_widget.dart';
import 'package:social_media_clone_flutter/src/features/home/domain/data/post_model.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart';
import 'package:social_media_clone_flutter/src/constants/app_colors.dart';

class PostContainerWidget extends StatefulWidget {
  final PostModel postDetail;

  const PostContainerWidget({super.key, required this.postDetail});

  @override
  State<PostContainerWidget> createState() => _PostContainerWidgetState();
}

class _PostContainerWidgetState extends State<PostContainerWidget> {
  late String userId;
  bool isLikeAnimating = false;
  final _firebaseAuthDi = getIt<FirebaseAuth>();

  @override
  void initState() {
    User? user = _firebaseAuthDi.currentUser;
    userId = user?.uid ?? '';

    super.initState();
  }

  Widget _placeholderImage() {
    return Image.asset(AssetPaths.imagePlaceHolder, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: primaryBgColor), color: primaryBgColor),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                    radius: 16,
                    child: ClipOval(
                      child: Image.asset(AssetPaths.userProfile,
                          fit: BoxFit.cover),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.postDetail.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          GestureDetector(
              onDoubleTap: () {
                context
                    .read<PostsCubit>()
                    .likePost(widget.postDetail.postId.toString(), userId);
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: widget.postDetail.isPending
                      ? Image.file(
                          File(widget.postDetail.postUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _placeholderImage(),
                        )
                      : widget.postDetail.postUrl.toString().isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.postDetail.postUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  _placeholderImage())
                          : _placeholderImage(),
                ),
                AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimationWidget(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(milliseconds: 400),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(Icons.favorite,
                            color: Colors.white, size: 100)))
              ])),
          Row(
            children: <Widget>[
              LikeAnimationWidget(
                  isAnimating: widget.postDetail.likes.contains(userId),
                  smallLike: true,
                  child: IconButton(
                      icon: widget.postDetail.likes.contains(userId)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                            ),
                      onPressed: () => context.read<PostsCubit>().likePost(
                          widget.postDetail.postId.toString(), userId))),
              IconButton(
                  icon: const Icon(
                    Icons.comment_sharp,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(
                    Icons.send_outlined,
                  ),
                  onPressed: () {}),
            ],
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Text(
                          '${widget.postDetail.likes.length} likes',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: widget.postDetail.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.postDetail.description}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(widget.postDetail.datePublished),
                        style: const TextStyle(color: secondaryColor))
                  ]))
        ],
      ),
    );
  }
}
