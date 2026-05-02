import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/features/todo/models/todo_model.dart';

class TodoController extends GetxController {
  final RxList<TodoModel> todos = <TodoModel>[].obs;
  final RxBool isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  StreamSubscription? _todoSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() {
    print("DEBUG: Fetching todos for user: ${_auth.currentUser?.uid}");
    _todoSubscription = getTodosStream().listen(
      (data) {
        print("DEBUG: Successfully fetched ${data.length} tasks");
        todos.assignAll(data);
      },
      onError: (error) {
        print("DEBUG: Firestore Error: $error");
        Get.snackbar("Error", "Could not load tasks: $error");
      },
    );
  }

  Stream<List<TodoModel>> getTodosStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
     return _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('todo')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TodoModel.fromSnapshot(doc)).toList());
  }

  Future<void> addTodo(String title, String description) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final todo = TodoModel(
        title: title,
        description: description,
        createdAt: DateTime.now(),
        isCompleted: false,
      );

      await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('todo')
          .add(todo.toMap());
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
    }
  }

  Future<void> toggleTodo(String id, bool isCompleted) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('todo')
          .doc(id)
          .update({'isCompleted': !isCompleted});
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('todo')
          .doc(id)
          .delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }

  @override
  void onClose() {
    _todoSubscription?.cancel();
    super.onClose();
  }
}
