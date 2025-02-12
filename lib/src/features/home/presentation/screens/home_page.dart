import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/constants/asset_paths.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart';
import 'package:social_media_clone_flutter/src/constants/app_colors.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/screens/widgets/post_card_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryBgColor,
            centerTitle: false,
            title: Row(
              children: [
                SvgPicture.asset(AssetPaths.browseInLogo,
                    color: primaryColor, height: 32),
                const SizedBox(width: 20),
                const Text(AppStrings.browseIn,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold))
              ],
            )),
        body: BlocBuilder<PostsCubit, PostsState>(
          builder: (context, state) {
            if (state is PostsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostsLoaded) {
              return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (ctx, index) =>
                      PostContainerWidget(postDetail: state.posts[index]));
            } else if (state is PostsError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return Container();
          },
        ));
  }
}
