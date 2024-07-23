import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider_app/components/neu_box.dart';
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

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
      volume:
          volumeEx, //Usecase>>> only define if you want each song starts with the initial volume value even if you changed it during the prev song
      widget.audioFile,
      autoStart: false,
      loopMode: LoopMode.single,
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
          child: StreamBuilder(
              stream: assetsAudioPlayer.realtimePlayingInfos,
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Text(
                          assetsAudioPlayer.getCurrentAudioArtist == ''
                              ? 'من فضلك قم بالتشغيل'
                              : assetsAudioPlayer.getCurrentAudioArtist,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NeuBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.asset(assetsAudioPlayer
                                          .getCurrentAudioImage?.path ??
                                      ''),
                                ),
                                NeuBox(
                                  child: getBtnWidget,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Padding(
                            //   padding: const EdgeInsets.all(15.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [

                            //       Text(
                            //         assetsAudioPlayer.getCurrentAudioArtist == ''
                            //             ? 'من فضلك قم بالتشغيل'
                            //             : assetsAudioPlayer.getCurrentAudioArtist,
                            //         style: const TextStyle(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 20),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                convertSeconds(valueEx),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17),
                              ),
                              const Icon(Icons.shuffle),
                              const Icon(Icons.repeat),
                              Text(
                                convertSeconds(
                                    snapshots.data?.duration.inSeconds ?? 0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Slider(
                            value: valueEx.toDouble(),
                            activeColor: Colors.green,
                            min: 0,
                            max:
                                snapshots.data?.duration.inSeconds.toDouble() ??
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SegmentedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0x00000000),
                        ),
                      ),
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
                );
              }),
        ),
      ),
    );
  }

  Widget get getBtnWidget => assetsAudioPlayer.builderIsPlaying(
        builder: (context, isPlaying) {
          return GestureDetector(
            onTap: () {
              if (isPlaying) {
                assetsAudioPlayer.pause();
              } else {
                assetsAudioPlayer.play();
              }
              setState(() {});
            },
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
