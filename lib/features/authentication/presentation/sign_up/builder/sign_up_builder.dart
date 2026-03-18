import 'package:flutter/material.dart';
import 'package:two_do/shared/custom_builder.dart';
import 'package:two_do/features/authentication/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:two_do/features/authentication/presentation/sign_up/context/sign_up_content.dart';
import 'package:two_do/shared/screen/error_screen.dart';
import 'package:two_do/shared/screen/success_screen.dart';

class SignUpBuilder extends StatelessWidget {
  const SignUpBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<SignUpCubit, SignUpState>(
      listenWhen: (context, state) => state is SignUpSuccess,
      listener:
          (context, state) => {
            if (state is SignUpSuccess)
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SuccessScreen('Sign Up Successful!'),
                  ),
                ),
              },
          },
      builder:
          (context, state) => switch (state) {
            SignUpFailure() => ErrorScreen(message: state.errorMessage),
            SignUpLoading() => const Center(child: CircularProgressIndicator()),
            _ => SignUpContent(),
          },
    );
  }
}
