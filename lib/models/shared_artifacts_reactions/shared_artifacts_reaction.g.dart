// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_artifacts_reaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedArtifactsReactionAdapter
    extends TypeAdapter<SharedArtifactsReaction> {
  @override
  final int typeId = 10;

  @override
  SharedArtifactsReaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedArtifactsReaction(
      id: fields[0] as String,
      value: fields[1] as String,
      dateCreated: fields[2] as DateTime,
      dateModified: fields[3] as DateTime,
      ownerId: fields[4] as String,
      ownerEmail: fields[5] as String,
      ownerUsername: fields[6] as String,
      sharedArtifactId: fields[7] as String,
      sharedPortfolioId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SharedArtifactsReaction obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.dateModified)
      ..writeByte(4)
      ..write(obj.ownerId)
      ..writeByte(5)
      ..write(obj.ownerEmail)
      ..writeByte(6)
      ..write(obj.ownerUsername)
      ..writeByte(7)
      ..write(obj.sharedArtifactId)
      ..writeByte(8)
      ..write(obj.sharedPortfolioId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedArtifactsReactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
