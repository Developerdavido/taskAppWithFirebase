import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_project_app/repository/firestore_repository.dart';
import '../../models/task.dart';
import '../bloc_exports.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<GetAllTask>(_onGetAllTasks);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    await FireStoreRepository.create(task: event.task);
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isDone: !event.task.isDone!);
    await FireStoreRepository.update(task: updatedTask);
  }

  void _onGetAllTasks(GetAllTask event, Emitter<TasksState> emit) async {
    List<Task> pendingTasks = [];
    List<Task> completedTasks = [];
    List<Task> favoriteTasks = [];
    List<Task> removedTasks = [];

    await FireStoreRepository.get().then((value) {
      value.forEach((task) {
        if (task.isDeleted == true) {
          removedTasks.add(task);
        } else {
          if (task.isFavorite == true) {
            favoriteTasks.add(task);
          }
          if (task.isDone == true) {
            completedTasks.add(task);
          }else {
            pendingTasks.add(task);
          }
        }
      });
    });
    emit(TasksState(
      completedTasks: completedTasks,
      pendingTasks: pendingTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: removedTasks
    ));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    await FireStoreRepository.delete(task: event.task);
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isDeleted: true);
    await FireStoreRepository.update(task: updatedTask);
  }

  void _onMarkFavoriteOrUnfavoriteTask(
      MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isFavorite: !event.task.isFavorite!);
    await FireStoreRepository.update(task: updatedTask);
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) async{
    await FireStoreRepository.update(task: event.newTask);
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isDeleted: false, isDone: false, date: DateTime.now().toString(), isFavorite: false);
    await FireStoreRepository.update(task: updatedTask);
  }

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async {
    await FireStoreRepository.deleteAllRemovedTasks(
      taskList: state.removedTasks
    );
  }


}
