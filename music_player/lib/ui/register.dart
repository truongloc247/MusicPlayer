import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/model/auth_api.dart';
import 'package:music_player/model/token.dart';
import 'package:music_player/model/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool isChecked = false;

  String name = '';
  int age = -1;
  bool gender = true;
  String phoneNumber = '';
  String address = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: registerForm());
  }

  Widget registerForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            decoration: InputDecoration(label: Text("Tên")),
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
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(label: Text("Tuổi")),
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
          CheckboxListTile(
            value: isChecked,
            title: const Text("Giới tính nam"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                isChecked = !isChecked;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text("Số điện thoại")),
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
          TextFormField(
            decoration: InputDecoration(label: Text("Địa chỉ")),
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
          TextFormField(
            decoration: InputDecoration(label: Text("Email")),
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
          TextFormField(
            decoration: InputDecoration(label: Text("Mật khẩu")),
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
          ElevatedButton(
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng ký thất bại')),
                  );
                }
              }
            },
            child: Text("Đăng ký"),
          ),
        ],
      ),
    );
  }
}
