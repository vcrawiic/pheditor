import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pheditor/pages/splash/splash_state.dart';
import 'package:pheditor/services/auth_service.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthService _authService;

  SplashCubit(this._authService) : super(const SplashInitial());

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (isClosed) return;

    final isLoggedIn = _authService.currentUser != null;
    if (isLoggedIn) {
      emit(const SplashNavigateToGallery());
    } else {
      emit(const SplashNavigateToAuth());
    }
  }
}
