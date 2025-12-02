import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class AiRepo {
  Future<String> summarize(String content) async {
    final response = await ApiClient.dio.post("/ai/summarize", data: {
      "content": content,
    });

    return response.data["data"]["summary"];
  }

  Future<String> improve(String content) async {
    final response = await ApiClient.dio.post("/ai/improve", data: {
      "content": content,
    });

    return response.data["data"]["improved"];
  }

  Future<String> tasks(String content) async {
    final response = await ApiClient.dio.post("/ai/tasks", data: {
      "content": content,
    });

    return response.data["data"]["tasks"];
  }

  Future<String> actions(String content) async {
    final response = await ApiClient.dio.post("/ai/actions", data: {
      "content": content,
    });

    return response.data["data"]["actions"];
  }

  Future<String> keywords(String content) async {
    final response = await ApiClient.dio.post("/ai/keywords", data: {
      "content": content,
    });

    return response.data["data"]["keywords"];
  }

  Future<String> transform(String content, String format) async {
    final response = await ApiClient.dio.post("/ai/transform", data: {
      "content": content,
      "format": format,
    });

    return response.data["data"]["result"];
  }

  Future<String> knowledge(String content) async {
    final response = await ApiClient.dio.post("/ai/knowledge", data: {
      "content": content,
    });

    return response.data["data"]["graph"];
  }
}
