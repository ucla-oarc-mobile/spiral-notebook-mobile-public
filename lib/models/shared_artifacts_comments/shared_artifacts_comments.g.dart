// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_artifacts_comments.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedArtifactsCommentsAdapter
    extends TypeAdapter<SharedArtifactsComments> {
  @override
  final int typeId = 9;

  @override
  SharedArtifactsComments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedArtifactsComments(
      (fields[0] as List).cast<SharedArtifactsComment>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedArtifactsComments obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.comments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedArtifactsCommentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
