import 'package:connectivity_plus/connectivity_plus.dart';

/// Exposes the device's real-time network connectivity status.
class ConnectivityService {
  final _connectivity = Connectivity();

  /// Stream that emits `true` when online and `false` when offline.
  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map((results) => !results.contains(ConnectivityResult.none));

  /// Returns the current online status as a one-shot check.
  Future<bool> checkIsOnline() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
