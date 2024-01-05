// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_portfolio.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedPortfolioAdapter extends TypeAdapter<SharedPortfolio> {
  @override
  final int typeId = 4;

  @override
  SharedPortfolio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedPortfolio(
      id: fields[0] as String,
      artifactIds: (fields[1] as List).cast<String>(),
      commentCount: fields[11] as int,
      dateCreated: fields[2] as DateTime,
      dateModified: fields[3] as DateTime,
      grades: (fields[4] as List).cast<String>(),
      name: fields[5] as String,
      ownerId: fields[12] as String,
      ownerName: fields[13] as String,
      plcGoals: fields[10] as String,
      plcName: fields[9] as String,
      structure: (fields[6] as List).cast<dynamic>(),
      subject: fields[7] as String,
      topic: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SharedPortfolio obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.topic)
      ..writeByte(9)
      ..write(obj.plcName)
      ..writeByte(10)
      ..write(obj.plcGoals)
      ..writeByte(11)
      ..write(obj.commentCount)
      ..writeByte(12)
      ..write(obj.ownerId)
      ..writeByte(13)
      ..write(obj.ownerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedPortfolioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
