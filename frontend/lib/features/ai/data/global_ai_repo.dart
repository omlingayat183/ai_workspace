import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class GlobalAiRepo {
  Future<String> ask(String question) async {
    final res = await ApiClient.dio.post(
      "/ai/notes/query",
      data: { "question": question },
    );

    return res.data["data"]["answer"];
  }

  // If you want a dedicated global summary later:
  Future<String> summarizeAll() async {
    final res = await ApiClient.dio.post(
      "/ai/notes/query",
      data: { "question": "Give me a full summary of all my notes." },
    );

    return res.data["data"]["answer"];
  }

  // Smart search (AI-based)
  Future<String> search(String query) async {
    final res = await ApiClient.dio.post(
      "/ai/notes/query",
      data: { "question": "Search my notes for: $query" },
    );

    return res.data["data"]["answer"];
  }
}
