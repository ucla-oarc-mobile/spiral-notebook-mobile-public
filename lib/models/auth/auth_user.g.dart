// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthUserAdapter extends TypeAdapter<AuthUser> {
  @override
  final int typeId = 2;

  @override
  AuthUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthUser(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String,
      isConfirmed: fields[3] as bool,
      isBlocked: fields[4] as bool,
      roleId: fields[5] as String,
      roleName: fields[6] as String,
      roleDescription: fields[7] as String,
      dateCreated: fields[8] as DateTime,
      dateModified: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AuthUser obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.isConfirmed)
      ..writeByte(4)
      ..write(obj.isBlocked)
      ..writeByte(5)
      ..write(obj.roleId)
      ..writeByte(6)
      ..write(obj.roleName)
      ..writeByte(7)
      ..write(obj.roleDescription)
      ..writeByte(8)
      ..write(obj.dateCreated)
      ..writeByte(9)
      ..write(obj.dateModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
