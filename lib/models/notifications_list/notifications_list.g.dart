// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationsListAdapter extends TypeAdapter<NotificationsList> {
  @override
  final int typeId = 7;

  @override
  NotificationsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationsList(
      (fields[0] as List).cast<NotificationsListItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationsList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.notifications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
