import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteConfigServiceProvider = Provider((ref) => RemoteConfigService());

class RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.setDefaults({
      "min_app_version": "1.0.0",
      "maintenance_mode": false,
      "feature_cascade_simulation": true,
      "dashboard_refresh_interval_sec": 30,
    });
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      // Handle fetch error or use defaults
    }
  }

  bool get maintenanceMode => remoteConfig.getBool("maintenance_mode");
  String get minVersion => remoteConfig.getString("min_app_version");
  bool get cascadeSimulationEnabled =>
    remoteConfig.getBool("feature_cascade_simulation");
    
  int get dashboardRefreshInterval => remoteConfig.getInt("dashboard_refresh_interval_sec");
}
