part of 'detail_bloc.dart';

enum DetailsPageStatus { initial, loading, loaded, failure }

class DetailState extends Equatable {
  const DetailState(
      {this.status = DetailsPageStatus.initial, this.currentProduct});

  final DetailsPageStatus status;
  final Product? currentProduct;

  DetailState copyWith({DetailsPageStatus? newStatus, Product? newProduct}) {
    return DetailState(
        status: newStatus ?? status,
        currentProduct: newProduct ?? currentProduct);
  }

  @override
  List<Object?> get props => [status, currentProduct];
}
