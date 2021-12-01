import 'package:Hercules/domain/usecases/profile_use_case.dart';
import 'package:Hercules/domain/usecases/registration_use_case.dart';
import 'package:Hercules/domain/usecases/social_auth_use_case.dart';
import 'package:Hercules/presentation/ui/resources/app_styles.dart';
import 'package:Hercules/presentation/ui/resources/images.dart';
import 'package:Hercules/presentation/ui/resources/locale_keys.g.dart';
import 'package:Hercules/presentation/ui/screens/auth/auth_cubit.dart';
import 'package:Hercules/presentation/ui/screens/auth/auth_state.dart';
import 'package:Hercules/presentation/ui/screens/auth/registration/registration_state.dart';
import 'package:Hercules/presentation/ui/screens/auth/widget/social_auth_panel.dart';
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
import 'package:flutter_svg/svg.dart';

import 'registration_cubit.dart';

class RegistrationScreen extends StatefulWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RegistrationScreen());
  }

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _confirmPasswordFieldController = TextEditingController();

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
        child: BlocProvider<RegistrationCubit>(
            create: (context) => RegistrationCubit(
                RegistrationUseCase(context.read()),
                profileUseCase
            ),
            child: BlocListener<RegistrationCubit, RegistrationState>(
                listener: _handleRegistrationState,
                child: BlocBuilder<RegistrationCubit, RegistrationState>(
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
                                                  Images.registrationBg,
                                                  height: MediaQuery.of(context).size.height,
                                                  fit: BoxFit.fill
                                              ),
                                              _createTopBody(context)
                                            ],
                                          )
                                      ),
                                      _createBottomBody(context)
                                    ]
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 32),
                                  child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icon(Icons.arrow_back, color: Colors.white)
                                  ),
                                ),
                                if (state is RegistrationLoading) LoadingWidget()
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
          _createRegistrationTitle(),
          SizedBox(height: 24),
          WhiteInputField(
            LocaleKeys.email.tr(),
            controller: _emailFieldController,
          ),
          SizedBox(height: 24),
          WhiteInputField(
            LocaleKeys.password.tr(),
            controller: _passwordFieldController,
            isPassword: true,
          ),
          SizedBox(height: 24),
          WhiteInputField(
            LocaleKeys.confirmPassword.tr(),
            controller: _confirmPasswordFieldController,
            isPassword: true,
          ),
          SizedBox(height: 40),
          SecondaryButton(LocaleKeys.signUp.tr(), () => _signUp(context))
        ],
      ),
    );
  }

  Widget _createRegistrationTitle() {
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
          LocaleKeys.signUp.tr(),
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
        height: MediaQuery.of(context).size.height * 0.25,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SocialAuthPanel(
            LocaleKeys.orLoginWith.tr(),
            (type) => context.read<AuthCubit>().signInBySocialAuth(type)
        )
    );
  }

  void _signUp(BuildContext context) {
    final email = _emailFieldController.text;
    final password = _passwordFieldController.text;
    final confirmPassword = _confirmPasswordFieldController.text;

    if (email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password != confirmPassword) {
        ToastUtils.showToast(LocaleKeys.passwordMismatch.tr());
      } else {
        UiUtils.unfocus(context);
        context.read<RegistrationCubit>().signUp(email, password);
      }
    }
  }

  void _handleRegistrationState(BuildContext context, RegistrationState state) {
    if (state is RegistrationSuccess) {
      final route = state.isMyProfileCreated
          ? HomeScreen.route()
          : ProfileCreationScreen.route();
      Navigator.pushReplacement(context, route);
    } else if (state is RegistrationFailure) {
      String message;
      if (state is InvalidEmail) {
        message = LocaleKeys.invalidEmail.tr();
      } else if (state is WeakPassword) {
        message = LocaleKeys.passwordIsTooWeak.tr();
      } else if (state is EmailAlreadyInUse) {
        message = LocaleKeys.emailAlreadyInUse.tr();
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
    _confirmPasswordFieldController.dispose();
    super.dispose();
  }
}