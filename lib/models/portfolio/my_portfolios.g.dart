// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_portfolios.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyPortfoliosAdapter extends TypeAdapter<MyPortfolios> {
  @override
  final int typeId = 1;

  @override
  MyPortfolios read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyPortfolios(
      (fields[0] as List).cast<Portfolio>(),
    );
  }

  @override
  void write(BinaryWriter writer, MyPortfolios obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.portfolios);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyPortfoliosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
