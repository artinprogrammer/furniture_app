// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingProductAdapter extends TypeAdapter<ShoppingProduct> {
  @override
  final int typeId = 2;

  @override
  ShoppingProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingProduct(
      id: fields[0] as int,
      categoryId: fields[1] as int,
      imageUrl: fields[2] as String,
      title: fields[3] as String,
      subtitle: fields[4] as String,
      color: fields[5] as String,
      description: fields[6] as String,
      rating: fields[7] as String,
      price: fields[8] as int,
      number: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingProduct obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.subtitle)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
