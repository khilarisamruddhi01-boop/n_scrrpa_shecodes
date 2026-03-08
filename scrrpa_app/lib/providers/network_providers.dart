import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/network_service.dart';

final networkResilienceProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.read(networkServiceProvider);
  return await service.getNetworkResilience();
});

final networkGraphProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.read(networkServiceProvider);
  return await service.getNetworkGraph();
});

final spofAnalysisProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.read(networkServiceProvider);
  return await service.getSpofAnalysis();
});
