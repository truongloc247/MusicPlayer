import 'package:dio/dio.dart';
import 'package:music_player/model/token.dart';
import 'package:music_player/model/user.dart';

class AuthApi {
  Future<Token?> register(User user) async {
    var headers = {'Content-Type': 'application/json'};

    var dio = Dio();

    try {
      var response = await dio.request(
        'http://localhost:3000/register',
        options: Options(method: 'POST', headers: headers),
        data: user.toJson(),
      );

      if (response.statusCode == 201) {
        return Token.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      return null;
    }
  }
}
