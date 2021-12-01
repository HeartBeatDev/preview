import 'package:Hercules/domain/usecases/profile_use_case.dart';
import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:Hercules/presentation/ui/screens/auth/login/login_screen.dart';
import 'package:Hercules/presentation/ui/screens/home/home_screen.dart';
import 'package:Hercules/presentation/ui/screens/profile/creation/profile_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_cubit.dart';
import 'splash_state.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
        create: (context) => SplashCubit(ProfileUseCase(context.read())),
        child: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            _handleState(context, state);
          },
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.defaultGradientTopColor,
                      AppColors.defaultGradientBottomColor
                    ],
                  )
              ),
            ),
          ),
        )
    );
  }

  void _handleState(BuildContext context, SplashState state) {
    if (state is NavigateToLogin) {
      Navigator.pushReplacement(context, LoginScreen.route());
    } else if (state is NavigateToHome) {
      Navigator.pushReplacement(context, HomeScreen.route());
    } else if (state is NavigateToProfileCreation) {
      Navigator.pushReplacement(context, ProfileCreationScreen.route());
    }
  }
}
