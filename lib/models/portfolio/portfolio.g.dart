// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PortfolioAdapter extends TypeAdapter<Portfolio> {
  @override
  final int typeId = 0;

  @override
  Portfolio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Portfolio(
      id: fields[0] as String,
      artifactIds: (fields[1] as List).cast<String>(),
      dateCreated: fields[2] as DateTime,
      dateModified: fields[3] as DateTime,
      grades: (fields[4] as List).cast<String>(),
      name: fields[5] as String,
      structure: (fields[6] as List).cast<dynamic>(),
      subject: fields[7] as String,
      topic: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Portfolio obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.artifactIds)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.dateModified)
      ..writeByte(4)
      ..write(obj.grades)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.structure)
      ..writeByte(7)
      ..write(obj.subject)
      ..writeByte(8)
      ..write(obj.topic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
