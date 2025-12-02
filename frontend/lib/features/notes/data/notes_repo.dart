import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'note_model.dart';

class NotesRepo {
  Future<List<NoteModel>> getNotes() async {
  final response = await ApiClient.dio.get("/notes");

  final list = response.data["data"]["notes"] as List;

  return list.map((n) => NoteModel.fromJson(n)).toList();
}


  Future<NoteModel> createNote(String title, String content) async {
    final response = await ApiClient.dio.post("/notes", data: {
      "title": title,
      "content": content,
    });

    if (response.data["success"] != true || response.data["data"] == null) {
  throw Exception(response.data["message"] ?? "Failed to create note");
}

return NoteModel.fromJson(response.data["data"]);

  }

  Future<NoteModel> updateNote(String id, String title, String content) async {
    final response = await ApiClient.dio.put("/notes/$id", data: {
      "title": title,
      "content": content,
    });

    return NoteModel.fromJson(response.data["data"]);
  }

  Future<void> deleteNote(String id) async {
    await ApiClient.dio.delete("/notes/$id");
  }
}
