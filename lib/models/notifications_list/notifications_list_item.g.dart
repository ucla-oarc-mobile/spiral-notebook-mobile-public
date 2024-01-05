// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_list_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationsListItemAdapter extends TypeAdapter<NotificationsListItem> {
  @override
  final int typeId = 6;

  @override
  NotificationsListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationsListItem(
      messageId: fields[0] as String,
      body: fields[1] as String,
      destination: fields[2] as String,
      isRead: fields[5] as bool,
      timestamp: fields[3] as DateTime,
      title: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationsListItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
