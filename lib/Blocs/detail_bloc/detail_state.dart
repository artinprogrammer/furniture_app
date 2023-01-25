part of 'detail_bloc.dart';

enum DetailsPageStatus { initial, loading, loaded, failure }

class DetailState extends Equatable {
  const DetailState(
      {this.status = DetailsPageStatus.initial,
      this.currentProduct,
      this.productColor,
      this.bookMarksList = const <Product>[]
      });

  final DetailsPageStatus status;
  final Product? currentProduct;
  final Color? productColor;
  final List<Product> bookMarksList;

  DetailState copyWith(
      {DetailsPageStatus? newStatus, Product? newProduct, Color? newColor,List<Product>? newBookMarksList}) {
    return DetailState(
        status: newStatus ?? status,
        currentProduct: newProduct ?? currentProduct,
        productColor: newColor ?? productColor,
        bookMarksList: newBookMarksList ?? bookMarksList
        );
  }

  @override
  List<Object?> get props => [status, currentProduct,productColor,bookMarksList];
}
