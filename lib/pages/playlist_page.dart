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
          "assets/sampl.mp3",
          metas: Metas(
              title: 'First Song',
              artist: 'Artist 1',
              image: const MetasImage.network(
                  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80')),
        ),
        Audio(
          "assets/sampl1.mp3",
          metas: Metas(
              title: 'Second Song',
              artist: 'Artist 2',
              image: const MetasImage.network(
                  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80')),
        ),
        Audio(
          "assets/sampl2.mp3",
          metas: Metas(
              title: 'Third Song',
              artist: 'Artist 3',
              image: const MetasImage.network(
                  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80')),
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
        title: const Center(child: Text('Songs PlayList')),
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
                        height: 270,
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
              ]),

              // CarouselSlider(
              //   options: CarouselOptions(
              //     clipBehavior: Clip.none,
              //     height: 260,
              //     autoPlay: true,
              //   ),
              //   items: playlistEx!.audios.map((i) {
              //     return Builder(
              //       builder: (BuildContext context) {
              //         return SongWidget(audio: i);
              //       },
              //     );
              //   }).toList(),
              // ),
            ),
    );
  }
}
