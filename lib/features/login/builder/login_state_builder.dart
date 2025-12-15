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
        if (state is LoginSuccess) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Login Successful!',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
          );
        }
        return const LoginContent();
      },
    );
  }
}
