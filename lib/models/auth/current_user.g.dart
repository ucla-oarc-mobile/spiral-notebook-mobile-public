// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentAuthUserAdapter extends TypeAdapter<CurrentAuthUser> {
  @override
  final int typeId = 3;

  @override
  CurrentAuthUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentAuthUser(
      myUser: fields[0] as AuthUser?,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentAuthUser obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.myUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentAuthUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
