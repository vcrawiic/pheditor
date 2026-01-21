import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pheditor/services/auth_service.dart';
import 'auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Управление состоянием авторизации и регистрации
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  StreamSubscription? _authSubscription;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _init();
  }

  void _init() {
    _authSubscription = _authService.authStateChanges.listen((user) {
      if (!isClosed) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      }
    });
  }
  // Вход по e-mail
  Future<void> signIn(String email, String password) async {
    try {
      if (!isClosed) {
        emit(AuthLoading());
      }
      await _authService.signInWithEmail(email: email, password: password);
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e.toString()));
      }
    }
  }
  //Регистрация
  Future<void> signUp(String email, String password) async {
    try {
      if (!isClosed) {
        emit(AuthLoading());
      }
      await _authService.signUpWithEmail(email: email, password: password);
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
  //Выход
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (_) {
      debugPrint('logout error');
    }
  }
}
