import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story/new/story_list.dart';

part 'pagination_state.dart';

class PaginationCubit<T> extends Cubit<PaginationState> {
  PaginationCubit() : super(PaginationInitial());

  Future<void> addData(
      {required Iterable<StoryData<T>> data,
      required int pageIndex,
      T? myStory}) async {
    if (state is PaginationLoaded) {
      final oldData = (state as PaginationLoaded<T>).data;
      final prevMyStory = (state as PaginationLoaded).myStory;
      emit(PaginationLoaded<T>(
          data: [...oldData, ...data],
          pageIndex: pageIndex,
          myStory: prevMyStory));
    } else {
      emit(PaginationLoaded<T>(
          data: data, pageIndex: pageIndex, myStory: myStory));
    }
  }
}
