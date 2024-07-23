import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider_app/components/neu_box.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_app/pages/home.dart';

class SongWidget extends StatefulWidget {
  final Audio audio;
  const SongWidget({required this.audio, super.key});

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    assetsAudioPlayer.open(widget.audio, autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: NeuBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(widget.audio.metas.image?.path ?? ''),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.audio.metas.artist ?? 'No Artist'),
              StreamBuilder(
                  stream: assetsAudioPlayer.realtimePlayingInfos,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return const SizedBox.shrink();
                    }
                    return Text(widget.audio.metas.title ?? 'No Title');
                  }),
            ],
          ),
        ],
      )),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => HomePage(
                      audioFile: widget.audio,
                    )));
      },
    );
  }

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondsStr.padLeft(2, '0')}';
  }
}
