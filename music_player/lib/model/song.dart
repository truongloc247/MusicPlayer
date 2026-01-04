import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "source")
  String source;

  @JsonKey(name: "singer")
  String singer;

  @JsonKey(name: "image")
  String image;

  Song({
    required this.id,
    required this.name,
    required this.source,
    required this.singer,
    required this.image,
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);
}
