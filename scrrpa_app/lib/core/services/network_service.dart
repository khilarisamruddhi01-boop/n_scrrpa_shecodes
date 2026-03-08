import 'package:dio/dio.dart';
import 'api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkServiceProvider = Provider((ref) {
  return NetworkService(ref.read(apiServiceProvider));
});

class NetworkService {
  final ApiService _api;

  NetworkService(this._api);

  Future<Map<String, dynamic>> getNetworkResilience() async {
    try {
      final response = await _api.get('/network/resilience');
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['detail'] ?? e.message);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getNetworkGraph() async {
    try {
      final response = await _api.get('/network/graph');
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['detail'] ?? e.message);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSpofAnalysis() async {
    try {
      final response = await _api.get('/network/spof-analysis');
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['detail'] ?? e.message);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> runSimulation(String triggerNodeId, String eventType) async {
    try {
      final response = await _api.post('/simulation/run', data: {
        'trigger_node_id': triggerNodeId,
        'event_type': eventType,
      });
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['detail'] ?? e.message);
      }
      rethrow;
    }
  }
}
