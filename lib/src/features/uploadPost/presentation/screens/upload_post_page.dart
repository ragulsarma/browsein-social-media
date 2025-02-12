import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/features/uploadPost/presentation/bloc/post_upload_cubit.dart';
import 'package:social_media_clone_flutter/src/constants/app_colors.dart';
import 'package:social_media_clone_flutter/src/utils/image_picker_utils.dart';
import 'package:social_media_clone_flutter/src/utils/snack_bar_utils.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  File? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  late PostUploadCubit _cubit;

  @override
  void initState() {
    _cubit = getIt<PostUploadCubit>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _cubit,
        child: BlocListener<PostUploadCubit, PostUploadState>(
            listener: (context, state) {
              if (state is PostUploadSuccess) {
                showSnackBar(context, "Posted!");
                clearImage();
              } else if (state is PostUploadError) {
                showSnackBar(context, "Error: ${state.message}");
              }
            },
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: primaryBgColor,
                  title: const Text(AppStrings.uploadPost),
                  centerTitle: false,
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          if (_descriptionController.text.trim().isNotEmpty) {
                            _cubit.uploadPost(
                                _descriptionController.text.trim(),
                                _file?.path ?? '',
                                context);
                          }
                        },
                        child: const Text(AppStrings.post,
                            style: TextStyle(
                                color: secondaryOrangeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0)))
                  ]),
              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(children: <Widget>[
                    BlocBuilder<PostUploadCubit, PostUploadState>(
                      bloc: _cubit,
                      builder: (context, state) {
                        if (state is PostUploading) {
                          return const LinearProgressIndicator();
                        }
                        return const SizedBox();
                      },
                    ),
                    const Divider(),
                    (_file == null)
                        ? GestureDetector(
                            onTap: () async {
                              File getFile = await getImageFromGallery(
                                  ImageSource.gallery);
                              setState(() {
                                _file = getFile;
                              });
                            },
                            child: const Column(children: [
                              SizedBox(height: 25),
                              Icon(Icons.image, size: 35),
                              SizedBox(height: 10),
                              Text(AppStrings.uploadImage,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))
                            ]))
                        : SizedBox(
                            height: 150.0,
                            width: 150.0,
                            child: Image.file(_file!)),
                    const SizedBox(height: 50),
                    TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: AppStrings.writeCaption,
                            border: InputBorder.none),
                        maxLines: 5),
                    const Divider()
                  ])),
            )));
  }
}
