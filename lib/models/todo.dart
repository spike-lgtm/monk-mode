class TodoItem {
  final int id;
  final int parentId;
  final String title;
  final String? description;
  final bool finished;
  final DateTime addedAt;

  TodoItem({
    required this.id,
    required this.parentId,
    required this.title,
    this.description,
    required this.finished,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'title': title,
      'description': description,
      'finished': finished ? 1 : 0,
      'added_at': addedAt.toIso8601String(),
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      parentId: json['parent_id'],
      title: json['title'],
      description: json['description'],
      finished: json['finished'] == 1,
      addedAt: DateTime.parse(json['added_at']),
    );
  }
}
