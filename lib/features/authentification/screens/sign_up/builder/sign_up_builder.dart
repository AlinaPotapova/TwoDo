import 'package:flutter/material.dart';
import 'package:focus_app/core/custom_builder.dart';
import 'package:focus_app/features/authentification/screens/sign_up/cubit/sign_up_cubit.dart';
import 'package:focus_app/features/authentification/screens/sign_up/context/sign_up_page.dart';
import 'package:focus_app/shared/error_screen.dart';
import 'package:focus_app/shared/success_screen.dart';

class Sign_upBuilder extends StatelessWidget {
  const Sign_upBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<SignUpCubit, Sign_upState>(
      listenWhen: (context, state) => state is SignUpSuccess,
      listener: (context, state) => {
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
      builder: (context, state) => switch (state) {
        SignUpFailure() => ErrorScreen(message: state.errorMessage),
        SignUpLoading() => const Center(child: CircularProgressIndicator()),
        _ => Sign_upPage(),
      },
    );
  }
}
