import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/constants/asset_paths.dart';
import 'package:social_media_clone_flutter/src/features/login/presentation/screens/login_page.dart';
import 'package:social_media_clone_flutter/src/constants/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  Map<String, dynamic>? userData;
  final fireStore = getIt<FirebaseFirestore>();
  final _firebaseAuthDi = getIt<FirebaseAuth>();

  @override
  void initState() {
    super.initState();
    getMyDetails();
  }

  getMyDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await fireStore
          .collection('users')
          .doc(_firebaseAuthDi.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
    } catch (e) {
      debugPrint('Error..${e.toString()}');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: primaryBgColor,
                title: const Text(AppStrings.myProfile),
                centerTitle: false),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      CircleAvatar(
                          radius: 80,
                          child: ClipOval(
                            child: Image.asset(AssetPaths.userProfile,
                                fit: BoxFit.cover),
                          )),
                      const SizedBox(height: 20),
                      Text(userData?['username'] ?? '',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(userData?['email'] ?? '',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700])),
                      const SizedBox(height: 30),
                      InkWell(
                          onTap: () async {
                            await _firebaseAuthDi.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          },
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                color: secondaryOrangeColor,
                              ),
                              child: const Text(AppStrings.signOut,
                                  style: TextStyle(color: primaryColor))))
                    ],
                  ),
                ),
              ),
            ));
  }
}
