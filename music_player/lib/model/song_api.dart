import 'package:dio/dio.dart';
import 'package:music_player/model/song.dart';

class SongApi {
  Future<List<Song>?> getAllSongs(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var dio = Dio();

    try {
      var response = await dio.request(
        'http://localhost:3000/660/songs',
        options: Options(method: 'GET', headers: headers),
      );

      if (response.statusCode == 200) {
        List songs = response.data;
        return songs.map((json) => Song.fromJson(json)).toList();
      }
      return null;
    } on DioException catch (e) {
      return null;
    }
  }
}
