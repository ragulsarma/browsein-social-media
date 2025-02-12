import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/features/login/data/my_user_model.dart';

part 'signin_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  final _fireStore = getIt<FirebaseFirestore>();
  final _firebaseAuthDi = getIt<FirebaseAuth>();

  void loginUser({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuthDi.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        emit(SignInSuccess());
      } else {
        emit(const SignInError("Please enter all required fields."));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(SignInError(e.toString()));
    }
  }

  void signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(SignUpLoading());
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        UserCredential cred =
            await _firebaseAuthDi.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await cred.user?.updateDisplayName(username);
        await cred.user?.reload();

        MyUserModel user = MyUserModel(
            username: username, uid: cred.user?.uid ?? '', email: email);

        // adding user into firebase DB
        await _fireStore
            .collection("users")
            .doc(cred.user?.uid ?? '')
            .set(user.toJson());

        emit(SignUpSuccess());
      } else {
        emit(const SignUpError("Please enter all required fields."));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(SignUpError(e.toString()));
    }
  }
}
