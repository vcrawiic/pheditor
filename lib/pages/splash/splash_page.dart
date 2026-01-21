import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pheditor/dependencies/global_dependencies.dart';
import 'package:pheditor/navigation/routes.dart';
import 'package:pheditor/pages/splash/splash_cubit.dart';
import 'package:pheditor/pages/splash/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(GlobalDependencies.authService)..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToGallery) {
            context.go(AppRoutes.gallery);
          } else if (state is SplashNavigateToAuth) {
            context.go(AppRoutes.auth);
          }
        },
        child: Scaffold(
          body: Image.asset(
            'assets/pheditor.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
