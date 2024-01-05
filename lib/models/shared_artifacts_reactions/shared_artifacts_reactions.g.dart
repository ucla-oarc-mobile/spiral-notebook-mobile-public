// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_artifacts_reactions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedArtifactsReactionsAdapter
    extends TypeAdapter<SharedArtifactsReactions> {
  @override
  final int typeId = 11;

  @override
  SharedArtifactsReactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedArtifactsReactions(
      (fields[0] as List).cast<SharedArtifactsReaction>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedArtifactsReactions obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.reactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedArtifactsReactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
