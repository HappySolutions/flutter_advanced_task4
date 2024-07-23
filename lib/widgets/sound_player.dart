import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SoundPlayerWidget extends StatefulWidget {
  final Audio audioFile;
  const SoundPlayerWidget({required this.audioFile, super.key});

  @override
  State<SoundPlayerWidget> createState() => _SoundPlayerWidgetState();
}

class _SoundPlayerWidgetState extends State<SoundPlayerWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  int valueEx = 0;
  double volumeEx = 1.0;
  double playSpeedEx = 1.0;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
      volume:
          volumeEx, //Usecase>>> only define if you want each song starts with the initial volume value even if you changed it during the prev song
      widget.audioFile,
      autoStart: false,
      loopMode: LoopMode.playlist,
    );
    assetsAudioPlayer.playSpeed.listen((event) {
      playSpeedEx = event;
    });
    assetsAudioPlayer.volume.listen((event) {
      volumeEx = event;
    });

    assetsAudioPlayer.currentPosition.listen((event) {
      valueEx = event.inSeconds;
    });
  }

  void changePlaySpeed(Set<double> values) {
    playSpeedEx = values.first.toDouble();
    assetsAudioPlayer.setPlaySpeed(playSpeedEx);
    setState(() {});
  }

  void changeVolume(Set<double> values) {
    volumeEx = values.first.toDouble();
    assetsAudioPlayer.setVolume(volumeEx);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(children: [
            Container(
              height: 600,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              child: Center(
                child: StreamBuilder(
                    stream: assetsAudioPlayer.realtimePlayingInfos,
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              assetsAudioPlayer.getCurrentAudioTitle == ''
                                  ? 'Please play your Songs'
                                  : assetsAudioPlayer.getCurrentAudioTitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: snapshots.data?.current?.index == 0
                                      ? null
                                      : () {
                                          assetsAudioPlayer.previous();
                                        },
                                  icon: const Icon(Icons.skip_previous),
                                ),
                                getBtnWidget,
                                IconButton(
                                  onPressed: snapshots.data?.current?.index ==
                                          (assetsAudioPlayer.playlist?.audios
                                                      .length ??
                                                  0) -
                                              1
                                      ? null
                                      : () {
                                          assetsAudioPlayer.next();
                                        },
                                  icon: const Icon(Icons.skip_next),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Volume',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SegmentedButton(
                                      onSelectionChanged: (values) {
                                        changeVolume(values);
                                      },
                                      segments: const [
                                        ButtonSegment(
                                          value: 1.0,
                                          icon: Icon(Icons.volume_up),
                                        ),
                                        ButtonSegment(
                                          value: 0.5,
                                          icon: Icon(Icons.volume_down),
                                        ),
                                        ButtonSegment(
                                          value: 0.0,
                                          icon: Icon(Icons.volume_mute),
                                        ),
                                      ],
                                      selected: {volumeEx},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                const Text(
                                  'Speed',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SegmentedButton(
                                      onSelectionChanged: (values) {
                                        changePlaySpeed(values);
                                      },
                                      segments: const [
                                        ButtonSegment(
                                          value: 1.0,
                                          icon: Text('1X'),
                                        ),
                                        ButtonSegment(
                                          value: 4.0,
                                          icon: Text('2X'),
                                        ),
                                        ButtonSegment(
                                          value: 8.0,
                                          icon: Text('3X'),
                                        ),
                                        ButtonSegment(
                                          value: 16.0,
                                          icon: Text('4X'),
                                        ),
                                      ],
                                      selected: {playSpeedEx},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Slider(
                              value: valueEx.toDouble(),
                              min: 0,
                              max: snapshots.data?.duration.inSeconds
                                      .toDouble() ??
                                  0.0,
                              onChanged: (value) async {
                                // await assetsAudioPlayer.seek(
                                //   Duration(seconds: value.toInt()),
                                // );
                                setState(() {
                                  valueEx = value.toInt();
                                });
                              },
                              onChangeEnd: (value) async {
                                await assetsAudioPlayer.seek(
                                  Duration(seconds: value.toInt()),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              '${convertSeconds(valueEx)} / ${convertSeconds(snapshots.data?.duration.inSeconds ?? 0)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget get getBtnWidget => assetsAudioPlayer.builderIsPlaying(
        builder: (context, isPlaying) {
          return FloatingActionButton.large(
            onPressed: () {
              if (isPlaying) {
                assetsAudioPlayer.pause();
              } else {
                assetsAudioPlayer.play();
              }
              setState(() {});
            },
            shape: const CircleBorder(),
            child: assetsAudioPlayer.builderIsPlaying(
              builder: (context, isPlaying) {
                return Icon(isPlaying ? Icons.pause : Icons.play_arrow);
              },
            ),
          );
        },
      );

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondsStr.padLeft(2, '0')}';
  }
}
