import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_app/widgets/song_widget.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Playlist? playlistEx = Playlist();
  Uint8List? imagevalue;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    playlistEx = Playlist(
      audios: [
        Audio(
          "assets/1.mp3",
          metas: Metas(
            title: 'الفجر',
            artist: 'عبدالمجيد السريح',
            image: const MetasImage.asset('assets/1.jpeg'),
          ),
        ),
        Audio(
          "assets/2.mp3",
          metas: Metas(
            title: 'الظهر',
            artist: 'ناصر القطامي',
            image: const MetasImage.asset('assets/2.jpeg'),
          ),
        ),
        Audio(
          "assets/3.mp3",
          metas: Metas(
            title: 'العصر',
            artist: 'وديع اليمني',
            image: const MetasImage.asset('assets/3.jpeg'),
          ),
        ),
        Audio(
          "assets/4.mp3",
          metas: Metas(
            title: 'المغرب',
            artist: 'مولانا كورتيش',
            image: const MetasImage.asset('assets/4.jpeg'),
          ),
        ),
        Audio(
          "assets/5.mp3",
          metas: Metas(
            title: 'العشاء',
            artist: 'اسلام صبحي',
            image: const MetasImage.asset('assets/5.jpeg'),
          ),
        ),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 237, 237),
        title: const Center(child: Text('قائمة المؤذن')),
      ),
      body: playlistEx!.audios.isEmpty
          ? const CircularProgressIndicator()
          : Center(
              child: Column(children: [
                Expanded(
                  child: CarouselSlider(
                    items: playlistEx!.audios.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SongWidget(audio: i);
                        },
                      );
                    }).toList(),
                    carouselController: _controller,
                    options: CarouselOptions(
                        height: 340,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_outlined),
                        onPressed: () => _controller.previousPage(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            playlistEx!.audios.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                        onPressed: () => _controller.nextPage(),
                      ),
                    ],
                  ),
                ),
              ],),
            ),
    );
  }
}
