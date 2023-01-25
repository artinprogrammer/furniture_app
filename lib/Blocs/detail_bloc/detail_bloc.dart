import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/repositories/bookmark_repository/bookmark_repository.dart';

import '../../data/models/product.dart';
import '../../data/repositories/detail_repository/detail_repository.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(
      {required DetialRepository detailRepository,
      required BookMarkRepository bookMarkRepository})
      : _detialRepository = detailRepository,
        _bookMarkRepository = bookMarkRepository,
        super(const DetailState()) {
    on<CurrentProductIdChanged>(_getNewProduct);
    on<AddToBookMarksEvent>(_addToBookMarks);
    on<DeleteFromBookMarksEvent>(_deleteFromBookMarks);
  }
  final DetialRepository _detialRepository;
  final BookMarkRepository _bookMarkRepository;

  Future<void> _getNewProduct(
      CurrentProductIdChanged event, Emitter<DetailState> emit) async {
    emit(state.copyWith(
      newStatus: DetailsPageStatus.loading,
    ));
    try {
      Product newProduct =
          await _detialRepository.getProductDetails(event.newId);

      var productColor;
      switch (newProduct.color) {
        case "brown":
          productColor = Colors.brown;
          break;
        case "black":
          productColor = Colors.black;
          break;
        case "white":
          productColor = Colors.white;
          break;
        case "gold":
          productColor = const Color.fromARGB(255, 255, 230, 0);
          break;
        case "pink":
          productColor = Colors.pink;
          break;
        case "green":
          productColor = Colors.green;
          break;
        case "blue":
          productColor = Colors.blue;
          break;
        case "grey":
          productColor = Colors.grey;
          break;
      }
      await _bookMarkRepository.init();
      var bookMarksList = _bookMarkRepository.getBookMarks();
      emit(state.copyWith(
          newStatus: DetailsPageStatus.loaded,
          newProduct: newProduct,
          newColor: productColor,
          newBookMarksList: bookMarksList
          ));
    } catch (e) {
      emit(state.copyWith(newStatus: DetailsPageStatus.failure));
    }
  }

  Future<void> _addToBookMarks(
      AddToBookMarksEvent event, Emitter<DetailState> emit) async {
    await _bookMarkRepository.addBookMark(state.currentProduct!);
    var result = _bookMarkRepository.getBookMarks();
    log(result.length.toString());
    emit(state.copyWith(newBookMarksList: result));
  }

  Future<void> _deleteFromBookMarks(
      DeleteFromBookMarksEvent event, Emitter<DetailState> emit) async {
    await _bookMarkRepository.deleteBookMark(state.currentProduct!);
    var result = await _bookMarkRepository.getBookMarks();
    emit(state.copyWith(newBookMarksList: result));
  }
}
