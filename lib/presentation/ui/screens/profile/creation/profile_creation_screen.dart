import 'package:Hercules/domain/usecases/create_profile_user_case.dart';
import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:Hercules/presentation/ui/resources/app_styles.dart';
import 'package:Hercules/presentation/ui/resources/images.dart';
import 'package:Hercules/presentation/ui/resources/locale_keys.g.dart';
import 'package:Hercules/presentation/ui/screens/home/home_screen.dart';
import 'package:Hercules/presentation/ui/utils/toast_utils.dart';
import 'package:Hercules/presentation/ui/utils/ui_utils.dart';
import 'package:Hercules/presentation/ui/widgets/loading_widget.dart';
import 'package:Hercules/presentation/ui/widgets/secondary_button.dart';
import 'package:Hercules/presentation/ui/widgets/unfocus.dart';
import 'package:Hercules/presentation/ui/widgets/white_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

import 'profile_creation_cubit.dart';
import 'profile_creation_state.dart';

class ProfileCreationScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProfileCreationScreen());
  }

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {

  final _nameFieldController = TextEditingController();

  bool isTrainer = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCreationCubit>(
      create: (context) => ProfileCreationCubit(CreateProfileUseCase(context.read())),
      child: BlocListener<ProfileCreationCubit, ProfileCreationState>(
          listener: _handleState,
          child: BlocBuilder<ProfileCreationCubit, ProfileCreationState>(
              builder: (context, state) {
                return Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: AppColors.primaryColor,
                    body: UnfocusWidget(
                        child: Stack(
                          children: [
                            Container(
                            margin: EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 120,
                                    height: 120,
                                    child: SvgPicture.asset(Images.emptyAvatar)
                                ),
                                SizedBox(height: 32),
                                WhiteInputField(
                                  LocaleKeys.enterName.tr(),
                                  controller: _nameFieldController,
                                ),
                                SizedBox(height: 32),
                                Row(
                                  children: [
                                    Text(
                                        LocaleKeys.iAmTrainer.tr(),
                                        style: AppStyles.getDefaultBoldTextStyle(
                                          size: 20,
                                          color: Colors.white,
                                        )
                                    ),
                                    Switch(value: isTrainer, onChanged: (isChecked) {
                                      setState(() {
                                        isTrainer = isChecked;
                                      });
                                    })
                                  ],
                                ),
                                SizedBox(height: 40),
                                SecondaryButton(
                                    LocaleKeys.create.tr(), () => _createProfile(context)
                                )
                              ],
                            ),
                          ),
                            if (state is ProfileCreationLoading) LoadingWidget()
                          ],
                        )
                    )
                );
              }
              )
      ),
    );
  }

  void _createProfile(BuildContext context) {
    final name = _nameFieldController.text;
    if (name.isEmpty) {
      ToastUtils.showToast(LocaleKeys.fillAllFields.tr());
    } else {
      UiUtils.unfocus(context);
      context.read<ProfileCreationCubit>().createProfile(name, isTrainer);
    }
  }

  void _handleState(BuildContext context, ProfileCreationState state) {
    if (state is ProfileCreationSuccess) {
      Navigator.pushAndRemoveUntil(context, HomeScreen.route(), (_) => false);
    } else if (state is ProfileCreationFailure) {
      ToastUtils.showToast(LocaleKeys.accountCreationError.tr());
    }
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }
}
