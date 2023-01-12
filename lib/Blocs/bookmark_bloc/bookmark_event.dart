part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class RegisterBookmarkServicesEvent extends BookmarkEvent{}

class LoadBookmarksEvent extends BookmarkEvent {}

class AddBookmarkEvent extends BookmarkEvent {
  final Product bookmarkToAdd;

  const AddBookmarkEvent(this.bookmarkToAdd);

  @override
  List<Object> get props => [bookmarkToAdd];
}

class DeleteBookmarkEvent extends BookmarkEvent {
  final Product bookmarkToDelete;

  const DeleteBookmarkEvent(this.bookmarkToDelete);

  @override
  List<Object> get props => [bookmarkToDelete];
}
