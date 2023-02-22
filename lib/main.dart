import 'package:flutter/material.dart';

import 'Views/song_list.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const SongList(),
    },
  ));
}
