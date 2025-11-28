import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_app/features/login/content/login_content.dart';
import 'package:focus_app/features/login/content/login_error_content.dart';
import 'package:focus_app/features/login/cubit/cubit/login_cubit.dart';

class LoginStateBuilder extends StatelessWidget {
  const LoginStateBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoginFailure) {
          return LoginErrorContent(message: state.message);
        }    
        if (state is LoginLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const LoginContent(user: null);
      },
    );
  }
}
