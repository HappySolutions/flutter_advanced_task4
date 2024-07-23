import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider_app/widgets/sound_player.dart';

class HomePage extends StatefulWidget {
  final Audio audioFile;

  const HomePage({required this.audioFile, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SoundPlayerWidget(
          audioFile: widget.audioFile,
        ),
      ),
    );
  }
}
