import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_app/features/authentication/domain/auth_repository.dart';
import 'package:focus_app/features/authentication/presentation/sign_up/builder/sign_up_builder.dart';
import 'package:focus_app/features/authentication/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(Get.find<AuthRepository>()),
      child: const SignUpBuilder(),
    );
  }
}
