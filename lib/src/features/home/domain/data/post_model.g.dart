// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 0;

  @override
  PostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostModel(
      id: fields[11] as String,
      postId: fields[1] as String,
      username: fields[2] as String,
      email: fields[3] as String,
      postUrl: fields[4] as String,
      likes: (fields[5] as List).cast<String>(),
      description: fields[6] as String,
      datePublished: fields[7] as DateTime,
      uid: fields[9] as String,
      isPending: fields[10] as bool,
      isLiked: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.postId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.postUrl)
      ..writeByte(5)
      ..write(obj.likes)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.datePublished)
      ..writeByte(8)
      ..write(obj.isLiked)
      ..writeByte(9)
      ..write(obj.uid)
      ..writeByte(10)
      ..write(obj.isPending)
      ..writeByte(11)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
