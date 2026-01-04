// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  source: json['source'] as String,
  singer: json['singer'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'source': instance.source,
  'singer': instance.singer,
  'image': instance.image,
};
