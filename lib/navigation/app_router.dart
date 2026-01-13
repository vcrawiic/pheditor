import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pheditor/DI/global_dependencies.dart';
import 'package:pheditor/navigation/routes.dart';
import 'package:pheditor/pages/auth_page/auth_page.dart';
import 'package:pheditor/pages/canvas/canvas_page.dart';
import 'package:pheditor/pages/gallery/gallery_page.dart';

final rootNavigationKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigationKey,
  initialLocation: AppRoutes.gallery,
  redirect: (context, state) {
    final isLoggedIn = GlobalDependencies.authService.currentUser != null;
    final isOnAuth = state.matchedLocation == AppRoutes.auth;

    if (!isLoggedIn && !isOnAuth) {
      return AppRoutes.auth;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: AppRoutes.gallery,
      builder: (context, state) => GalleryPage(),
    ),
    GoRoute(
      path: AppRoutes.canvas,
      builder: (context, state) => CanvasPage(),
    ),
  ],
);
