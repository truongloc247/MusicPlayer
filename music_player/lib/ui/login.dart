import 'package:flutter/material.dart';
import 'package:music_player/model/auth_api.dart';
import 'package:music_player/model/request/user_login_request.dart';
import 'package:music_player/model/token.dart';
import 'package:music_player/ui/register.dart';
import 'package:music_player/ui/song_player.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = true;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đăng nhập',
          style: TextStyle(
            color: Color(0xFF5D4DCB),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shadowColor: Color(0xFF5D4DCB),
      ),
      body: loginForm(),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(40),
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 6, color: Color(0xFF5D4DCB)),
                borderRadius: BorderRadius.circular(55),
              ),
              child: Text(
                "iJik",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4DCB),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF5D4DCB)),
              label: Text("Email", style: TextStyle(color: Color(0xFF5D4DCB))),
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email không được để trống";
              }
              RegExp emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(value)) {
                return "Email không hợp lệ";
              }
              return null;
            },
            onSaved: (value) {
              email = value!;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            obscureText: isPasswordVisible,
            decoration: InputDecoration(
              label: Text(
                "Mật khẩu",
                style: TextStyle(color: Color(0xFF5D4DCB)),
              ),
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF5D4DCB)),
              suffixIcon: isPasswordVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = false;
                        });
                      },
                      icon: Icon(Icons.visibility, color: Color(0xFF5D4DCB)),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = true;
                        });
                      },
                      icon: Icon(
                        Icons.visibility_off,
                        color: Color(0xFF5D4DCB),
                      ),
                    ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Mật khẩu không được để trống";
              }
              return null;
            },
            onSaved: (value) {
              password = value!;
            },
          ),
          SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5D4DCB),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                UserLoginRequest userLoginRequest = UserLoginRequest(
                  email: email,
                  password: password,
                );
                AuthApi authApi = AuthApi();
                Token? token = await authApi.login(userLoginRequest);
                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng nhập thất bại')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng nhập thành công')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongPlayer(token: token),
                    ),
                  );
                }
              }
            },
            child: Text(
              "ĐĂNG NHẬP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5D4DCB),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: Text(
              "CHƯA CÓ TÀI KHOẢN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
