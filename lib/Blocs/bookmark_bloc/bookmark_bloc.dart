import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniture_app/data/repositories/bookmark_repository/bookmark_repository.dart';

import '../../data/models/product.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc({required BookMarkRepository bookMarkRepository})
      : _bookMarkRepository = bookMarkRepository,
        super(const BookmarkState()) {
    on<RegisterBookmarkServicesEvent>(_registerServices);
    on<LoadBookmarksEvent>(_loadBookmarks);
    on<AddBookmarkEvent>(_addBookmark);
    on<DeleteBookmarkEvent>(_deleteBookmark);
  }
  final BookMarkRepository _bookMarkRepository;

  Future<void> _registerServices(
      RegisterBookmarkServicesEvent event, Emitter<BookmarkState> emit) async {
    await _bookMarkRepository.init();
    add(LoadBookmarksEvent());
  }

  void _loadBookmarks(LoadBookmarksEvent event, Emitter<BookmarkState> emit) {
    emit(state.copyWith(newStatus: BookmarkStatus.loading));
    try {
      var bookmarks = _bookMarkRepository.getBookMarks();
      emit(state.copyWith(
          newStatus: BookmarkStatus.loaded, newBookmarks: bookmarks));
    } catch (e) {
      emit(state.copyWith(newStatus: BookmarkStatus.failure));
    }
  }

  Future<void> _addBookmark(
      AddBookmarkEvent event, Emitter<BookmarkState> emit) async {
    await _bookMarkRepository.addBookMark(event.bookmarkToAdd);
    add(LoadBookmarksEvent());
  }

  Future<void> _deleteBookmark(
      DeleteBookmarkEvent event, Emitter<BookmarkState> emit) async {
    await _bookMarkRepository.deleteBookMark(event.bookmarkToDelete);
    add(LoadBookmarksEvent());
  }
}
