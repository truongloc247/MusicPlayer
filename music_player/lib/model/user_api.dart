import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:music_player/model/user.dart';

class UserApi {
  Future<User?> getUserInfo(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    var headers = {'Authorization': 'Bearer $token'};

    var dio = Dio();
    try {
      var response = await dio.request(
        'http://localhost:3000/600/users/${decodedToken["sub"]}',
        options: Options(method: 'GET', headers: headers),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      return null;
    }
  }
}
