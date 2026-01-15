import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Отслеживание состояния сети. Уведомляет подписчиков через onStatusChange
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _statusController = StreamController<bool>.broadcast();

  bool _isConnected = true;
  bool get isConnected => _isConnected;
  Stream<bool> get onStatusChange => _statusController.stream;

  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = _hasConnection(result);

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final connected = _hasConnection(result);
      if (_isConnected != connected) {
        _isConnected = connected;
        _statusController.add(connected);
      }
    });
  }

  bool _hasConnection(List<ConnectivityResult> result) {
    return result.any((r) => r != ConnectivityResult.none);
  }

  Future<bool> check() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = _hasConnection(result);
    return _isConnected;
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
