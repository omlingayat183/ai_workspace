class NoteModel {
  final String id;
  final String title;
  final String content;
  final bool isDeleted;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isDeleted,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json["_id"],
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      isDeleted: json["isDeleted"] ?? false,
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
