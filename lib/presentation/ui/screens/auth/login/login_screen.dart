import 'dart:io';

import 'package:Hercules/domain/usecases/login_use_case.dart';
import 'package:Hercules/domain/usecases/profile_use_case.dart';
import 'package:Hercules/domain/usecases/social_auth_use_case.dart';
import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:Hercules/presentation/ui/resources/images.dart';
import 'package:Hercules/presentation/ui/resources/locale_keys.g.dart';
import 'package:Hercules/presentation/ui/resources/app_styles.dart';
import 'package:Hercules/presentation/ui/screens/auth/auth_cubit.dart';
import 'package:Hercules/presentation/ui/screens/auth/login/widget/forgot_password_dialog.dart';
import 'package:Hercules/presentation/ui/screens/auth/registration/registration_screen.dart';
import 'package:Hercules/presentation/ui/screens/home/home_screen.dart';
import 'package:Hercules/presentation/ui/screens/profile/creation/profile_creation_screen.dart';
import 'package:Hercules/presentation/ui/utils/toast_utils.dart';
import 'package:Hercules/presentation/ui/utils/ui_utils.dart';
import 'package:Hercules/presentation/ui/widgets/loading_widget.dart';
import 'package:Hercules/presentation/ui/widgets/secondary_button.dart';
import 'package:Hercules/presentation/ui/widgets/unfocus.dart';
import 'package:Hercules/presentation/ui/widgets/white_input_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../auth_state.dart';
import 'login_cubit.dart';
import '../social_auth_type.dart';
import 'login_state.dart';

class LoginScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileUseCase = ProfileUseCase(context.read());
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(
          SocialAuthUseCase(context.read()),
          profileUseCase
      ),
      child: BlocListener<AuthCubit, AuthState>(
        listener: _handleSocialAuthState,
        child: BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(
                LoginUseCase(context.read()),
                profileUseCase
            ),
            child: BlocListener<LoginCubit, LoginState>(
                listener: _handleLoginState,
                child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return Scaffold(
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Colors.white,
                          body: UnfocusWidget(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                        child: Stack(
                                          children: [
                                            SvgPicture.asset(
                                                Images.loginBg,
                                                height: MediaQuery.of(context).size.height,
                                                fit: BoxFit.fill
                                            ),
                                            _createTopBody(context),
                                          ]
                                        )
                                    ),
                                    _createBottomBody(context)
                                  ]
                                ),
                                if (state is LoginLoading) LoadingWidget()
                              ],
                            ),
                          )
                      );
                    }
                    )
            )
        ),
      ),
    );
  }

  Widget _createTopBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createLoginTitle(),
          SizedBox(height: 24),
          WhiteInputField(
            LocaleKeys.email.tr(),
            controller: _emailFieldController,
          ),
          SizedBox(height: 24),
          WhiteInputField(LocaleKeys.password.tr(),
              controller: _passwordFieldController,
              isPassword: true,
              rightView: Container(
                padding: EdgeInsets.only(top: 2),
                child: GestureDetector(
                  onTap: () => _showForgotPasswordDialog(context),
                  child: Text(
                    LocaleKeys.forgot.tr(),
                    style: AppStyles.getDefaultBoldTextStyle(size: 12),
                  ),
                ),
              )),
          SizedBox(height: 40),
          SecondaryButton(LocaleKeys.signIn.tr(), () => _signIn(context)),
          SizedBox(height: 24),
          GestureDetector(
            onTap: () => _signUp(context),
            child: Text(
              LocaleKeys.dontHaveAccount.tr(),
              style: AppStyles.getDefaultTextStyle(size: 14, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _createLoginTitle() {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
        SizedBox(width: 8),
        Text(
          LocaleKeys.login.tr(),
          style:
              AppStyles.getDefaultBoldTextStyle(color: Colors.white, size: 36),
        ),
        SizedBox(width: 8),
        Container(
          width: 6,
          height: 6,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        )
      ],
    );
  }

  Widget _createBottomBody(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: _createSocialAuthPanel(context));
  }

  Widget _createSocialAuthPanel(BuildContext context) {
    bool isAppleEnabled = Platform.isIOS;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 2, color: AppColors.lightGreyTextColor)),
            SizedBox(width: 16),
            Text(LocaleKeys.orLoginWith.tr(),
                style: AppStyles.getDefaultTextStyle(
                    color: AppColors.lightGreyTextColor)),
            SizedBox(width: 16),
            Expanded(child: Divider(height: 2, color: AppColors.lightGreyTextColor)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: isAppleEnabled
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.spaceEvenly,
          children: [
            _createSocialAuthButton(
                context,
                SvgPicture.asset(Images.icGoogle, height: 20, width: 20),
                SocialAuthType.google),
            _createSocialAuthButton(
                context,
                SvgPicture.asset(Images.icFacebook, height: 22, width: 22),
                SocialAuthType.facebook),
            if (isAppleEnabled)
              _createSocialAuthButton(
                  context,
                  Container(
                    padding: EdgeInsets.only(bottom: 2),
                    child: SvgPicture.asset(Images.icApple, height: 22, width: 22),
                  ),
                  SocialAuthType.ios)
          ],
        ),
        SizedBox(height: 40)
      ],
    );
  }

  Widget _createSocialAuthButton(BuildContext context, Widget logo, SocialAuthType type) {
    return GestureDetector(
      onTap: () => _signInBySocialType(context, type),
      child: Container(
          height: 40,
          width: 85,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.socialButtonOutlineColor),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: logo),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => ForgotPasswordDialog((email) =>
            _resetPassword(context, email)
        )
    );
  }

  void _signIn(BuildContext context) {
    final email = _emailFieldController.text;
    final password = _passwordFieldController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      UiUtils.unfocus(context);
      context.read<LoginCubit>().signIn(email, password);
    }
  }

  void _signUp(BuildContext context) {
    Navigator.push(context, RegistrationScreen.route());
  }

  void _resetPassword(BuildContext context, String email) {
    context.read<LoginCubit>().resetPassword(email);
  }

  void _signInBySocialType(BuildContext context, SocialAuthType type) {
    context.read<AuthCubit>().signInBySocialAuth(type);
  }

  void _handleLoginState(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      final route = state.isMyProfileCreated
          ? HomeScreen.route()
          : ProfileCreationScreen.route();
      Navigator.pushReplacement(context, route);
    } else if (state is LoginFailure) {
      String message;
      if (state is InvalidEmail) {
        message = LocaleKeys.invalidEmail.tr();
      } else if (state is UnknownUser) {
        message = LocaleKeys.unknownUser.tr();
      } else if (state is WrongPassword) {
        message = LocaleKeys.wrongPassword.tr();
      } else {
        message = state.exception.message ?? LocaleKeys.authError.tr();
      }
      ToastUtils.showToast(message);
    }
  }

  void _handleSocialAuthState(BuildContext context, AuthState state) {
    if (state is SocialAuthSuccess) {
      final route = state.isMyProfileCreated
          ? HomeScreen.route()
          : ProfileCreationScreen.route();
      Navigator.pushReplacement(context, route);
    } else if(state is SocialAuthFailure) {
      ToastUtils.showToast(state.exception.message ?? LocaleKeys.authError.tr());
    }
  }

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }
}