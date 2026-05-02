import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isCompleted;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isCompleted,
  });

  factory TodoModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return TodoModel(
      id: doc.id,
      title: data?['title'] ?? 'Untitled',
      description: data?['description'] ?? '',
      createdAt: data?['createdAt'] != null 
          ? (data!['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      isCompleted: data?['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
    };
  }
}
