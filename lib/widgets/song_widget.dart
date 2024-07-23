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
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: NeuBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(widget.audio.metas.image?.path ?? ''),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.audio.metas.artist ?? 'لا إسم'),
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
}
