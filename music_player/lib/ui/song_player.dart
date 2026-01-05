import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/model/position_data.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/model/song_api.dart';
import 'package:music_player/model/token.dart';
import 'package:rxdart/rxdart.dart';

class SongPlayer extends StatefulWidget {
  SongPlayer({super.key, required this.token});

  Token token;

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  late SongApi songApi;
  late Future<List<Song>?> songs;

  late Song? playingSong;

  final AudioPlayer audioPlayer = AudioPlayer();

  double? _dragValue;

  @override
  void initState() {
    songApi = SongApi();
    songs = songApi.getAllSongs(widget.token.token);
    playingSong = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 400, child: renderPlayingSong(playingSong)),
          Expanded(child: songList()),
        ],
      ),
    );
  }

  Widget renderPlayingSong(Song? song) {
    if (song == null) {
      return Center(child: Text("Hãy chọn bài hát muốn phát"));
    }
    return Column(
      children: [
        Image.network(song.image, width: 200, height: 200, fit: BoxFit.cover),
        Text(song.name),
        Text(song.singer),
        renderSongSlider(),
        renderPlayingController(),
      ],
    );
  }

  Widget renderPlayingController() {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snap) {
        final playerState = snap.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const CircularProgressIndicator();
        }
        if (playing != true) {
          return IconButton(
            iconSize: 64,
            icon: const Icon(Icons.play_circle_fill),
            onPressed: audioPlayer.play,
          );
        }
        if (processingState != ProcessingState.completed) {
          return IconButton(
            iconSize: 64,
            icon: const Icon(Icons.pause_circle_filled),
            onPressed: audioPlayer.pause,
          );
        }
        return IconButton(
          iconSize: 64,
          icon: const Icon(Icons.replay),
          onPressed: () {
            audioPlayer.pause();
            audioPlayer.seek(Duration.zero);
            audioPlayer.play();
          },
        );
      },
    );
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  Widget renderSongSlider() {
    return StreamBuilder<PositionData>(
      stream: positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        final position = positionData?.position ?? Duration.zero;
        final duration = positionData?.duration ?? Duration.zero;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Slider(
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                value:
                    _dragValue ??
                    position.inSeconds.toDouble().clamp(
                      0,
                      duration.inSeconds.toDouble(),
                    ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                },

                onChangeEnd: (value) {
                  audioPlayer.pause();
                  audioPlayer.seek(Duration(seconds: value.toInt()));
                  audioPlayer.play();
                  setState(() {
                    _dragValue = null;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position)),
                  Text(_formatDuration(duration)),
                ],
              ),
            ],
          ),
        );
      },
    );
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

  Future<void> playSpecificSong(String url) async {
    try {
      await audioPlayer.stop();

      await audioPlayer.setUrl(url);

      audioPlayer.play();
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  Widget renderSong(Song song) {
    return InkWell(
      onTap: () async {
        setState(() {
          playingSong = song;
        });
        await playSpecificSong(song.source);
      },
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

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}
