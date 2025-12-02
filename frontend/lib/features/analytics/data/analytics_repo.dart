import '../../../core/network/api_client.dart';

class AnalyticsRepo {
  Future<Map<String, dynamic>> getSummary() async {
    final r = await ApiClient.dio.get("/analytics/summary");
    return r.data["data"] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getRecentNotes() async {
    final r = await ApiClient.dio.get("/analytics/recent");
    return (r.data["data"] as List<dynamic>);
  }

  Future<List<dynamic>> getAiUsage({int days = 14}) async {
    final r = await ApiClient.dio.get("/analytics/ai-usage?days=$days");
    return (r.data["data"] as List<dynamic>);
  }
}
