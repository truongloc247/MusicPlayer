import 'package:flutter/material.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/model/song_api.dart';
import 'package:music_player/model/token.dart';

class SongPlayer extends StatefulWidget {
  SongPlayer({super.key, required this.token});

  Token token;

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  late SongApi songApi;
  late Future<List<Song>?> songs;

  @override
  void initState() {
    songApi = SongApi();
    songs = songApi.getAllSongs(widget.token.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: songList());
  }

  Widget songList() {
    return FutureBuilder(
      future: songs,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasError) {
            return Center(child: Text("Lỗi: ${snap.error}"));
          }
          if (snap.data == null) {
            return Center(child: Text("Lấy dữ liệu thất bại"));
          }
          return renderSongs(snap.data!);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget renderSongs(List<Song> songs) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return renderSong(songs[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
    );
  }

  Widget renderSong(Song song) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          // color: Color(0xFFF9F8FF),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: Image.network(
                song.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF5D4DCB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      song.singer,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
