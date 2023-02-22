import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RainbowPlayer extends StatefulWidget {
  final String artist;
  final String title;
  final String image;
  final String audio;
  const RainbowPlayer({
    Key? key,
    required this.artist,
    required this.title,
    required this.image,
    required this.audio,
  }) : super(key: key);

  @override
  State<RainbowPlayer> createState() => _RainbowPlayerState();
}

class _RainbowPlayerState extends State<RainbowPlayer>
    with TickerProviderStateMixin {
  AssetsAudioPlayer myPlayer = AssetsAudioPlayer();
  Duration max = Duration.zero;
  AnimationController? myIconController;
  SliderComponentShape? myThumb = SliderComponentShape.noThumb;

  @override
  void initState() {
    super.initState();

    myIconController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );

    myPlayer
        .open(
          Audio(widget.audio),
          autoStart: true,
          showNotification: true,
        )
        .then((value) => {
              setState(() {
                max = myPlayer.current.value!.audio.duration;
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
    myPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rainbow Player",
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    widget.title,
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.artist,
                    style: GoogleFonts.openSans(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // IconButton(
                      //   onPressed: () {
                      //     myPlayer.seekBy(const Duration(seconds: -10));
                      //     myPlayer.getCurrentAudioImage;
                      //   },
                      //   icon: const Icon(
                      //     Icons.skip_previous_outlined,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      IconButton(
                        onPressed: () {
                          myPlayer.stop();
                          setState(() {
                            myIconController!.reverse();
                          });
                        },
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      StreamBuilder(
                        stream: myPlayer.isPlaying,
                        builder: (context, snapShot) {
                          var val = snapShot.data;
                          val == true
                              ? myIconController!.forward()
                              : myIconController!.reverse();
                          return IconButton(
                            onPressed: () {
                              if (val == true) {
                                myPlayer.pause();
                              } else {
                                myPlayer.play();
                              }
                            },
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: myIconController!,
                              color: Colors.white,
                              size: 70,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            myPlayer.setVolume(0.0);
                          });
                        },
                        icon: const Icon(
                          Icons.headphones,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     myPlayer.seekBy(const Duration(seconds: 10));
                      //   },
                      //   icon: const Icon(
                      //     Icons.skip_next_outlined,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ],
                  ),
                  StreamBuilder(
                      stream: myPlayer.currentPosition,
                      builder: (context, snapShot) {
                        Duration? data = snapShot.data;
                        return SliderTheme(
                            data: SliderThemeData(
                              thumbShape: myThumb,
                              overlayColor: Colors.transparent,
                            ),
                            child: Slider(
                              min: 0,
                              max: max.inSeconds.toDouble(),
                              onChangeStart: (val) {
                                setState(() => myThumb = null);
                              },
                              onChangeEnd: (val) {
                                setState(() =>
                                    myThumb = SliderComponentShape.noThumb);
                              },
                              value:
                                  data == null ? 0 : data.inSeconds.toDouble(),
                              onChanged: (val) {
                                myPlayer.seek(
                                  Duration(seconds: val.toInt()),
                                );
                              },
                            ));
                      }),
                  StreamBuilder(
                      stream: myPlayer.currentPosition,
                      builder: (context, snapShot) {
                        var data = snapShot.data;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${data!.inMinutes} : ${data.inSeconds % 60}  ",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "/",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                " ${max.inMinutes} : ${max.inSeconds % 60}",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
