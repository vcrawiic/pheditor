import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pheditor/DI/global_dependencies.dart';
import 'package:pheditor/widgets/app_toast.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  StreamSubscription<bool>? _sub;
  bool _lastStatus = true;

  @override
  void initState() {
    super.initState();
    _lastStatus = GlobalDependencies.connectivityService.isConnected;
    _sub = GlobalDependencies.connectivityService.onStatusChange.listen(_handle);
  }

  void _handle(bool connected) {
    if (!mounted) return;

    if (!connected && _lastStatus) {
      AppToast.show(context, message: 'Нет подключения к интернету', type: ToastType.error);
    } else if (connected && !_lastStatus) {
      AppToast.show(context, message: 'Подключение восстановлено', type: ToastType.success);
    }
    _lastStatus = connected;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
