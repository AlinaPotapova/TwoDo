import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/tasks/domain/model/task.dart';
import 'package:two_do/features/tasks/domain/task_repository.dart';

/// Firebase implementation of [TaskRepository].
class FirebaseTaskRepository implements TaskRepository {
  FirebaseTaskRepository({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  DatabaseReference _getTasksRef() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return FirebaseDatabase.instance.ref().child('tasks').child(uid);
  }

  @override
  Stream<List<Task>> watchTasks() {
    return Stream.fromFuture(
      Future(() => _getTasksRef()),
    ).asyncExpand((ref) => ref.onValue).map((event) {
      final tasks = <Task>[];
      if (event.snapshot.value is Map) {
        final map = Map<String, dynamic>.from(event.snapshot.value as Map);
        map.forEach((key, value) {
          if (value is Map) {
            tasks.add(Task.fromMap(key, value));
          }
        });
      }
      return tasks;
    });
  }

  @override
  Future<Result<String>> addTask(Task task) async {
    try {
      final ref = _getTasksRef().push();
      await ref.set(task.toMap());
      return Success(ref.key ?? '');
    } catch (e, st) {
      developer.log(
        'Failed to add task',
        name: 'tasks',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      return Failure(
        'Failed to add task',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> updateTask(Task task) async {
    try {
      await _getTasksRef().child(task.id).update(task.toMap());
      return Success(null);
    } catch (e, st) {
      developer.log(
        'Failed to update task',
        name: 'tasks',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      return Failure(
        'Failed to update task',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> toggleComplete(Task task) async {
    try {
      await _getTasksRef().child(task.id).update({
        'isCompleted': task.isCompleted,
      });
      return Success(null);
    } catch (e, st) {
      developer.log(
        'Failed to toggle task completion',
        name: 'tasks',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      return Failure(
        'Failed to toggle task',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> deleteTask(String taskId) async {
    try {
      await _getTasksRef().child(taskId).remove();
      return Success(null);
    } catch (e, st) {
      developer.log(
        'Failed to delete task',
        name: 'tasks',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      return Failure(
        'Failed to delete task',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }
}
