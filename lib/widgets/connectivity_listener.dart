import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pheditor/DI/global_dependencies.dart';
import 'package:pheditor/navigation/app_router.dart';
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
    debugPrint('[ConnectivityListener] initState');
    _lastStatus = GlobalDependencies.connectivityService.isConnected;
    _sub = GlobalDependencies.connectivityService.onStatusChange.listen(_handle);
  }

  void _handle(bool connected) {
    debugPrint('[ConnectivityListener] _handle called: $connected');
    if (!mounted) return;

    final wasConnected = _lastStatus;
    _lastStatus = connected;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final overlay = rootNavigationKey.currentState?.overlay;
      if (overlay == null) return;

      if (!connected && wasConnected) {
        AppToast.showWithOverlay(overlay, message: 'Нет подключения к интернету', type: ToastType.error);
      } else if (connected && !wasConnected) {
        AppToast.showWithOverlay(overlay, message: 'Подключение восстановлено', type: ToastType.success);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
