import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_app/features/authentification/screens/sign_up/builder/sign_up_builder.dart';
import 'package:focus_app/features/authentification/screens/sign_up/cubit/sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => SignUpCubit(), child: Sign_upBuilder());
  }
}
