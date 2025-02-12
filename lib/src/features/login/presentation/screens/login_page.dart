import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/constants/asset_paths.dart';
import 'package:social_media_clone_flutter/src/core/presentation/widgets/text_field_input_widget.dart';
import 'package:social_media_clone_flutter/src/features/dashboard/dashboard_page.dart';
import 'package:social_media_clone_flutter/src/features/login/presentation/bloc/signin_cubit.dart';
import 'package:social_media_clone_flutter/src/constants/app_colors.dart';
import 'package:social_media_clone_flutter/src/features/login/presentation/screens/signup_page.dart';
import 'package:social_media_clone_flutter/src/utils/snack_bar_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SignInCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<SignInCubit>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: _buildUI(context)),
    );
  }

  BlocConsumer _buildUI(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AssetPaths.browseInLogo,
                      color: primaryColor, height: 64),
                  const SizedBox(width: 20),
                  const Text(AppStrings.browseIn,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 64),
              TextFieldInputWidget(
                  hintText: AppStrings.email,
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController),
              const SizedBox(height: 24),
              TextFieldInputWidget(
                  hintText: AppStrings.password,
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true),
              const SizedBox(height: 24),
              InkWell(
                  onTap: () {
                    _cubit.loginUser(
                        email: _emailController.text,
                        password: _passwordController.text);
                  },
                  child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: secondaryOrangeColor,
                      ),
                      child: BlocBuilder<SignInCubit, SignInState>(
                        bloc: _cubit,
                        builder: (context, state) {
                          if (state is SignInLoading) {
                            return const CircularProgressIndicator(
                                color: primaryColor);
                          }
                          return const Text(
                            AppStrings.logIn,
                            style: TextStyle(color: primaryColor),
                          );
                        },
                      ))),
              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(AppStrings.noAccount)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupPage())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(AppStrings.signUp,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is SignInError) {
          showSnackBar(context, state.message);
        }
        if (state is SignInSuccess) {
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const DashboardPage()),
                (route) => false);
          }
        }
      },
    );
  }
}
