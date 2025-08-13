import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';

/// The main state: list of todos
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super(const []);

  /// CREATE: add a new todo
  void add(String title) {
    if (title.trim().isEmpty) return;
    final todo = Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    state = [...state, todo];
  }

  /// READ (get all) = just read state via the provider

  /// UPDATE: change title
  void updateTitle(String id, String newTitle) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(title: newTitle.trim()) else t,
    ];
  }

  /// UPDATE: toggle completed
  void toggle(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(completed: !t.completed) else t,
    ];
  }

  /// DELETE
  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}

/// StateNotifierProvider to expose the list + notifier
final todosProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((
  ref,
) {
  return TodoListNotifier();
});

/// Optional: derived provider examples (to show "providers" usage)
final incompleteCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((t) => !t.completed).length;
});
