import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pheditor/dependencies/global_dependencies.dart';
import 'package:pheditor/navigation/routes.dart';
import 'package:pheditor/pages/auth_page/auth_page.dart';
import 'package:pheditor/pages/auth_page/registration_page.dart';
import 'package:pheditor/pages/canvas/canvas_page.dart';
import 'package:pheditor/pages/canvas/canvas_args.dart';
import 'package:pheditor/pages/gallery/gallery_page.dart';
import 'package:pheditor/pages/splash/splash_page.dart';

final rootNavigationKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigationKey,
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    final isOnSplash = state.matchedLocation == AppRoutes.splash;
    if (isOnSplash) return null;

    final isLoggedIn = GlobalDependencies.authService.currentUser != null;
    final isOnAuthFlow =
        state.matchedLocation == AppRoutes.auth ||
        state.matchedLocation == AppRoutes.registration;

    if (!isLoggedIn && !isOnAuthFlow) {
      return AppRoutes.auth;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: AppRoutes.registration,
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: AppRoutes.gallery,
      builder: (context, state) => GalleryPage(),
    ),
    GoRoute(
      path: AppRoutes.canvas,
      builder: (context, state) {
        final args = state.extra as CanvasArgs? ?? const CanvasArgs.create();
        return CanvasPage(args: args);
      },
    ),
  ],
);
