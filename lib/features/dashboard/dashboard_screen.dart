import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';
import 'package:two_do/features/dashboard/content/dashboard_content.dart';
import 'package:two_do/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(Get.find<AuthRepository>()),
      child: DashboardContent(),
    );
  }
}
