import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/model/position_data.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/model/song_api.dart';
import 'package:music_player/model/token.dart';
import 'package:music_player/ui/rotating_album_art.dart';
import 'package:music_player/ui/user_info.dart';
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

  // Song? playingSong;

  late List<Song> playingSongList;

  // int? playingSongIndex;

  final AudioPlayer audioPlayer = AudioPlayer();

  bool isLoopOne = false;

  @override
  void initState() {
    songApi = SongApi();
    songs = songApi.getAllSongs(widget.token.token);
    // playingSong = null;
    super.initState();
  }

  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "iJik PLAYLIST",
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
      body: Column(
        children: [
          SizedBox(height: 390, child: renderPlayingSong()),
          Expanded(child: songList()),
        ],
      ),
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
              selected: true,
              onTap: () {
                // _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Thông tin người dùng"),
              // selected: _selectedIndex == 1,
              onTap: () async {
                // _onItemTapped(1);
                await audioPlayer.stop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfo(token: widget.token),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget renderPlayingSong() {
    // if (index == null) {
    //   return Center(child: Text("Hãy chọn bài hát muốn phát"));
    // }
    return StreamBuilder<int?>(
      stream: audioPlayer.currentIndexStream,
      builder: (context, snap) {
        final index = snap.data;

        if (index == null || playingSongList.isEmpty) {
          return Center(child: Text("Hãy chọn bài hát muốn phát"));
        }
        return Column(
          children: [
            // Image.network(
            //   playingSongList[index].image,
            //   width: 200,
            //   height: 200,
            //   fit: BoxFit.cover,
            // ),
            SizedBox(height: 10),
            StreamBuilder<bool>(
              stream: audioPlayer.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;

                return RotatingAlbumArt(
                  imageUrl: playingSongList[index].image,
                  isPlaying: isPlaying,
                );
              },
            ),
            SizedBox(height: 10),
            Text(
              playingSongList[index].name,
              style: TextStyle(
                color: Color(0xFF5D4DCB),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(playingSongList[index].singer, style: TextStyle(fontSize: 12)),
            SizedBox(height: 10),
            renderSongSlider(),
            SizedBox(height: 10),
            renderPlayingController(),
          ],
        );
      },
    );
  }

  Widget renderPlayingController() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFEDEBF9),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isLoopOne
                ? IconButton(
                    onPressed: () async {
                      await audioPlayer.setLoopMode(LoopMode.off);
                      setState(() {
                        isLoopOne = false;
                      });
                    },
                    icon: Icon(
                      Icons.repeat_one_rounded,
                      color: Color(0xFF5D4DCB),
                      size: 25,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      await audioPlayer.setLoopMode(LoopMode.one);
                      setState(() {
                        isLoopOne = true;
                      });
                    },
                    icon: Icon(Icons.repeat_one_rounded, size: 25),
                  ),
            StreamBuilder<SequenceState?>(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: () async {
                    if (audioPlayer.hasPrevious) {
                      audioPlayer.seekToPrevious();
                      audioPlayer.play();
                    } else {
                      await playSpecificSong(0);
                    }
                  },
                  icon: Icon(
                    Icons.skip_previous_rounded,
                    size: 45,
                    color: Color(0xFF5D4DCB),
                  ),
                );
              },
            ),
            renderPlayingButton(),
            StreamBuilder<SequenceState?>(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: () {
                    if (audioPlayer.hasNext) {
                      audioPlayer.seekToNext();
                      audioPlayer.play();
                    }
                  },
                  icon: Icon(
                    Icons.skip_next_rounded,
                    size: 45,
                    color: Color(0xFF5D4DCB),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () async {
                Random random = Random();
                await audioPlayer.seek(
                  Duration.zero,
                  index: random.nextInt(playingSongList.length),
                );
                audioPlayer.play();
              },
              icon: Icon(
                CupertinoIcons.shuffle,
                size: 21,
                color: Color(0xFF5D4DCB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderPlayingButton() {
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
            iconSize: 60,
            icon: const Icon(Icons.play_circle_fill),
            onPressed: audioPlayer.play,
            color: Color(0xFF5D4DCB),
          );
        }
        if (processingState != ProcessingState.completed) {
          return IconButton(
            iconSize: 60,
            icon: const Icon(Icons.pause_circle_filled),
            onPressed: audioPlayer.pause,
            color: Color(0xFF5D4DCB),
          );
        }
        return IconButton(
          iconSize: 60,
          icon: const Icon(Icons.replay),
          onPressed: () {
            audioPlayer.pause();
            audioPlayer.seek(Duration.zero);
            audioPlayer.play();
          },
          color: Color(0xFF5D4DCB),
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
        final buffered = positionData?.bufferedPosition ?? Duration.zero;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ProgressBar(
            progress: position,
            buffered: buffered,
            total: duration,

            onSeek: (duration) {
              audioPlayer.pause();
              audioPlayer.seek(duration);
              audioPlayer.play();
            },

            progressBarColor: Color(0xFF5D4DCB),
            baseBarColor: Colors.grey.withOpacity(0.24),
            bufferedBarColor: Color(0xFFEDEBF9),
            thumbColor: Color(0xFF5D4DCB),
            barHeight: 5.0,
            thumbRadius: 8.0,
            timeLabelLocation: TimeLabelLocation.below,
            timeLabelTextStyle: TextStyle(color: Color(0xFF5D4DCB)),
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
          if (audioPlayer.sequence.isEmpty) {
            playingSongList = snap.data!;
            List<AudioSource> audioSources = playingSongList
                .map(
                  (song) => AudioSource.uri(Uri.parse(song.source), tag: song),
                )
                .toList();
            audioPlayer.addAudioSources(audioSources);
          }
          return renderSongs(playingSongList);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget renderSongs(List<Song> songs) {
    return StreamBuilder(
      stream: audioPlayer.currentIndexStream,
      builder: (context, snapshot) {
        final playingSongIndex = snapshot.data;

        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final isSelected = playingSongIndex == index;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: isSelected ? Color(0xFFEDEBF9) : null,
              ),
              child: renderSong(index),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
        );
      },
    );
  }

  Future<void> playSpecificSong(int index) async {
    // setState(() {
    //   playingSongIndex = index;
    //   // playingSong = playingSongList[index];
    // });
    try {
      // await audioPlayer.stop();

      await audioPlayer.seek(Duration.zero, index: index);
      // await audioPlayer.setUrl(url);

      audioPlayer.play();
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  Widget renderSong(int index) {
    return InkWell(
      onTap: () async {
        // setState(() {
        //   playingSongIndex = index;
        //   // playingSong = playingSongList[index];
        // });
        await playSpecificSong(index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          // color: Color(0xFFF9F8FF),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(7),
                bottomLeft: Radius.circular(7),
              ),
              child: Image.network(
                playingSongList[index].image,
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
                      playingSongList[index].name,
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
                      playingSongList[index].singer,
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
