import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/features/dashboard/dashboard_page.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart';
import 'package:social_media_clone_flutter/src/features/login/presentation/bloc/signin_cubit.dart';
import 'package:social_media_clone_flutter/src/features/login/presentation/screens/login_page.dart';
import 'package:social_media_clone_flutter/src/features/uploadPost/presentation/bloc/post_upload_cubit.dart';
import 'package:social_media_clone_flutter/src/constants/app_colors.dart';

class SocialMediaCloneFlutter extends StatefulWidget {
  const SocialMediaCloneFlutter({super.key});

  @override
  State<SocialMediaCloneFlutter> createState() =>
      _SocialMediaCloneFlutterState();
}

class _SocialMediaCloneFlutterState extends State<SocialMediaCloneFlutter> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<SignInCubit>()),
          BlocProvider(create: (context) => getIt<PostUploadCubit>()),
          BlocProvider(create: (context) => getIt<PostsCubit>()..fetchPosts()),
        ],
        child: MaterialApp(
            title: AppStrings.browseIn,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark()
                .copyWith(scaffoldBackgroundColor: primaryBgColor),
            home: StreamBuilder(
                // Get user sign in status
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return const DashboardPage();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    }
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return const LoginPage();
                })));
  }
}
