import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pheditor/dependencies/global_dependencies.dart';
import 'package:pheditor/navigation/app_router.dart';
import 'package:pheditor/navigation/routes.dart';
import 'package:pheditor/pages/auth_page/auth_cubit.dart';
import 'package:pheditor/pages/auth_page/auth_state.dart';
import 'package:pheditor/widgets/connectivity_listener.dart';
import 'firebase_options.dart';

//Точка входа. Инициализация сервисов
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(GlobalDependencies.authService),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          final isOnSplash = appRouter.routerDelegate.currentConfiguration.fullPath == AppRoutes.splash;
          if (isOnSplash) return;

          if (state is Authenticated) {
            appRouter.go('/gallery');
          } else if (state is Unauthenticated) {
            appRouter.go('/auth');
          }
        },
        child: MaterialApp.router(
          theme: ThemeData(fontFamily: 'Roboto', useMaterial3: false),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          builder: (context, child) => ConnectivityListener(child: child!),
        ),
      ),
    );
  }
}
