import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  static final String _ping = dotenv.env['PING_SOURCE'] ?? '';
  final _connectivity = Connectivity();
  final _statusController = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isConnected = true;
  bool get isConnected => _isConnected;
  Stream<bool> get onStatusChange => _statusController.stream;

  ConnectivityService() {
    debugPrint('[Connectivity] Service created');
    _init();
  }

  Future<void> _init() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = await _hasConnection(result);
    debugPrint('[Connectivity] Initial status: $_isConnected');

    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> result) async {
    debugPrint('[Connectivity] Event received: $result');

    final connected = await _hasConnection(result);

    if (_isConnected != connected) {
      _isConnected = connected;
      debugPrint('[Connectivity] Status changed to: $connected');
      _statusController.add(connected);
    }
  }

  Future<bool> _hasConnection(List<ConnectivityResult> result) async {
    if (_ping.isEmpty) {
      debugPrint('[Connectivity] Ping source is empty, cant check connection');
      return false;
    }

    // other и none не считаем за соединение (iOS в авиарежиме даёт other)
    bool hasValidConnection = result.any(
      (r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet,
    );

    try {
      final response = await http
          .get(Uri.parse(_ping), headers: {'User-Agent': 'ping'})
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200 && hasValidConnection;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
