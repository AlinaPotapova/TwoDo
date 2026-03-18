import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/widgets.dart';

class AppBlocBuilder<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  const AppBlocBuilder({
    super.key,
    required this.builder,
    this.buildWhen, this.listenWhen, required this.listener,
  });

  final BlocWidgetBuilder<S> builder;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;
  final BlocWidgetListener<S> listener;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) => listener(context, state),
      listenWhen: listenWhen,
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

