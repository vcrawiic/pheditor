import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _statusController = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isConnected = true;
  bool get isConnected => _isConnected;
  Stream<bool> get onStatusChange => _statusController.stream;

  ConnectivityService() {
    debugPrint('[Connectivity] Service created');

    _connectivity.checkConnectivity().then((result) {
      _isConnected = _hasConnection(result);
      debugPrint('[Connectivity] Initial status: $_isConnected');
    });

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      debugPrint('[Connectivity] Event received: $result');
      final connected = _hasConnection(result);
      if (_isConnected != connected) {
        _isConnected = connected;
        debugPrint('[Connectivity] Status changed to: $connected');
        _statusController.add(connected);
      }
    });
  }

  bool _hasConnection(List<ConnectivityResult> result) {
    // other и none не считаем за соединение (iOS в авиарежиме даёт other)
    return result.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
