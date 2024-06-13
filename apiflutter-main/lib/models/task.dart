class Task {
  int? id;
  String title;
  String? description;
  String dueDate;
  bool
      isCompleted; // Alterando para bool para representar um estado verdadeiro/falso

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted
          ? 1
          : 0, // Convertendo para int (0 ou 1) ao salvar no banco
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'] == 1, // Convertendo de int para bool
    );
  }
}
