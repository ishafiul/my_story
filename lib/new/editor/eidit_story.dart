import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_editor/stories_editor.dart';

/// content container key
final GlobalKey contentKey = GlobalKey();

class EditStory extends StatelessWidget {
  const EditStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: contentKey,
        body: StoriesEditor(
          giphyKey: '6dSH8bdv9EkMosq7wdDwdeM8HepRsyG9',
          //fontFamilyList: const ['Shizuru', 'Aladin'],
          galleryThumbnailQuality: 300,
          //isCustomFontList: true,
          onDone: (uri) {
            debugPrint(uri);
            Share.shareFiles([uri]);
          },
        ));
  }
}
