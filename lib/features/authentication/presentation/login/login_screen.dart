import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_app/features/authentication/domain/auth_repository.dart';
import 'package:focus_app/features/authentication/presentation/login/builder/login_bloc_builder.dart';
import 'package:focus_app/features/authentication/presentation/login/cubit/cubit/login_cubit.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(Get.find<AuthRepository>()),
      child: LoginBlocBuilder(),
    );
  }
}
