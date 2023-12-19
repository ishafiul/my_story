part of 'pagination_cubit.dart';

@immutable
abstract class PaginationState {}

class PaginationInitial extends PaginationState {}

class PaginationLoaded<T> extends PaginationState {
  final Iterable<StoryData<T>> data;
  final T? myStory;
  final int pageIndex;

  PaginationLoaded({required this.data, required this.pageIndex, this.myStory});
}
