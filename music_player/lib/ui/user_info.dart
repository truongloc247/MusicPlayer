import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/model/token.dart';
import 'package:music_player/model/user.dart';
import 'package:music_player/model/user_api.dart';
import 'package:music_player/ui/song_player.dart';

class UserInfo extends StatefulWidget {
  UserInfo({super.key, required this.token});
  Token token;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late UserApi userApi;
  late Future<User?> user;

  @override
  void initState() {
    userApi = UserApi();
    user = userApi.getUserInfo(widget.token.token);
    super.initState();
  }

  // int _selectedIndex = 1;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "THÔNG TIN CÁ NHÂN",
          style: TextStyle(
            color: Color(0xFF5D4DCB),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: userInfo(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF5D4DCB)),
              child: Center(
                child: Text(
                  "iJik",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              title: Text("Playlist"),
              // selected: _selectedIndex == 0,
              onTap: () {
                // _onItemTapped(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongPlayer(token: widget.token),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Thông tin cá nhân"),
              selected: true,
              onTap: () {
                // _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget userInfo() {
    return FutureBuilder(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: $e"));
          }
          if (snapshot.data == null) {
            return Center(
              child: Text(
                "Tải dữ liệu thất bại",
                style: TextStyle(
                  color: Color(0xFF5D4DCB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return renderUserInfo(snapshot.data!);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget renderUserInfo(User user) {
    return ListView(
      padding: EdgeInsets.all(25),
      children: [
        Row(
          spacing: 20,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 6, color: Color(0xFF5D4DCB)),
                borderRadius: BorderRadius.circular(55),
              ),
              child: Text(
                "iJik",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4DCB),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  Text(user.email),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 50),
        Text('Số điện thoại: ${user.phoneNumber}'),
        Divider(color: Color(0xFFEDEBF9)),
        Text('Địa chỉ: ${user.address}'),
        Divider(color: Color(0xFFEDEBF9)),
        Text('Giới tính: ${user.gender ? 'Nam' : 'Nữ'}'),
        Divider(color: Color(0xFFEDEBF9)),
        Text('Tuổi: ${user.age}'),
      ],
    );
  }
}
