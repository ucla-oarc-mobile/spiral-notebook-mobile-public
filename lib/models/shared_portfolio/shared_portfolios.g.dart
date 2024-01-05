// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_portfolios.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedPortfoliosAdapter extends TypeAdapter<SharedPortfolios> {
  @override
  final int typeId = 5;

  @override
  SharedPortfolios read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedPortfolios(
      (fields[0] as List).cast<SharedPortfolio>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedPortfolios obj) {
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
      other is SharedPortfoliosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
