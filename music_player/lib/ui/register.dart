import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/model/auth_api.dart';
import 'package:music_player/model/token.dart';
import 'package:music_player/model/user.dart';
import 'package:music_player/ui/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool isChecked = false;

  bool isPasswordVisible = true;

  String name = '';
  int age = -1;
  bool gender = true;
  String phoneNumber = '';
  String address = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đăng ký tài khoản',
          style: TextStyle(
            color: Color(0xFF5D4DCB),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shadowColor: Color(0xFF5D4DCB),
      ),
      body: registerForm(),
    );
  }

  Widget registerForm() {
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
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              label: Text("Tên", style: TextStyle(color: Color(0xFF5D4DCB))),
              prefixIcon: Icon(Icons.person_outline, color: Color(0xFF5D4DCB)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tên không được để trống';
              }
              return null;
            },
            onSaved: (value) {
              name = value!;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              label: Text("Tuổi", style: TextStyle(color: Color(0xFF5D4DCB))),
              prefixIcon: Icon(Icons.cake_outlined, color: Color(0xFF5D4DCB)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tuổi không được để trống';
              }
              int? age = int.tryParse(value);
              if (age == null) {
                return 'Tuổi không hợp lệ';
              }
              if (age < 6) {
                return 'Tuổi không được nhỏ hơn 6';
              }
              return null;
            },
            onSaved: (value) {
              age = int.parse(value!);
            },
          ),
          SizedBox(height: 15),
          CheckboxListTile(
            value: isChecked,
            title: const Text(
              "Giới tính nam",
              style: TextStyle(color: Color(0xFF5D4DCB)),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                isChecked = !isChecked;
              });
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              label: Text(
                "Số điện thoại",
                style: TextStyle(color: Color(0xFF5D4DCB)),
              ),
              prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF5D4DCB)),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Số điện thoại không được để trống';
              }
              RegExp phoneRegex = RegExp(r'^0\d{9}$');
              if (!phoneRegex.hasMatch(value)) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
            onSaved: (value) {
              phoneNumber = value!;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              label: Text(
                "Địa chỉ",
                style: TextStyle(color: Color(0xFF5D4DCB)),
              ),
              prefixIcon: Icon(Icons.home_outlined, color: Color(0xFF5D4DCB)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Địa chỉ không được để trống";
              }
              return null;
            },
            onSaved: (value) {
              address = value!;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              label: Text("Email", style: TextStyle(color: Color(0xFF5D4DCB))),
              prefixIcon: Icon(Icons.alternate_email, color: Color(0xFF5D4DCB)),
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
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF5D4DCB)),
              label: Text(
                "Mật khẩu",
                style: TextStyle(color: Color(0xFF5D4DCB)),
              ),
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
              if (value.length < 4) {
                return "Mật khẩu phải trên 3 ký tự";
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
                User user = User(
                  name: name,
                  age: age,
                  gender: isChecked,
                  phoneNumber: phoneNumber,
                  address: address,
                  email: email,
                  password: password,
                );
                AuthApi authApi = AuthApi();
                Token? token = await authApi.register(user);
                if (token != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng ký thành công')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng ký thất bại')),
                  );
                }
              }
            },
            child: Text(
              "ĐĂNG KÝ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
