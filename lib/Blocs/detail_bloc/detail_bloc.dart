import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/product.dart';
import '../../data/repositories/detail_repository/detail_repository.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc({required DetialRepository detailRepository})
      : _detialRepository = detailRepository,
        super(const DetailState()) {
    on<CurrentProductIdChanged>(_getNewProduct);
  }
  final DetialRepository _detialRepository;

  Future<void> _getNewProduct(
      CurrentProductIdChanged event, Emitter<DetailState> emit) async {
    emit(state.copyWith(
      newStatus: DetailsPageStatus.loading,
    ));
    try {
      Product newProduct =
          await _detialRepository.getProductDetails(event.newId);
      emit(state.copyWith(
          newStatus: DetailsPageStatus.loaded, newProduct: newProduct));
    } catch (e) {
      emit(state.copyWith(newStatus: DetailsPageStatus.failure));
    }
  }
}
