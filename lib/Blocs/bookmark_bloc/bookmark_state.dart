part of 'bookmark_bloc.dart';

enum BookmarkStatus { initial, loading, loaded, failure }

class BookmarkState extends Equatable {
  const BookmarkState(
      {this.status = BookmarkStatus.initial,
      this.bookmarks = const <Product>[],
      this.lastAddedBookmark});

  final List<Product> bookmarks;
  final BookmarkStatus status;
  final Product? lastAddedBookmark;

  BookmarkState copyWith({
    BookmarkStatus? newStatus,
    List<Product>? newBookmarks,
    Product? newLastAddedBookmark,
  }){
    return BookmarkState(
      status: newStatus ?? status,
      bookmarks: newBookmarks ?? bookmarks,
      lastAddedBookmark: newLastAddedBookmark ?? lastAddedBookmark
    );
  }

  @override
  List<Object?> get props => [bookmarks, status, lastAddedBookmark];
}
