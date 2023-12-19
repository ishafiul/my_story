import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/providers/notifiers/control_provider.dart';
import '../../domain/providers/notifiers/draggable_widget_notifier.dart';
import '../../domain/providers/notifiers/painting_notifier.dart';
import '../../domain/providers/notifiers/scroll_notifier.dart';
import '../../domain/sevices/save_as_image.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  final Widget? onDoneButtonStyle;

  /// editor background color
  final Color? editorBackgroundColor;

  const BottomTools(
      {Key? key,
      required this.contentKey,
      required this.onDone,
      this.onDoneButtonStyle,
      this.editorBackgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer4<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier,
        PaintingNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier,
          paintingProvider, __) {
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// preview gallery
                if (controlNotifier.mediaPath.isNotEmpty)
                  Flexible(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: _preViewContainer(
                          /// if [model.imagePath] is null/empty return preview image
                          child: controlNotifier.mediaPath.isEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: GestureDetector(
                                    onTap: () {
                                      /// scroll to gridView page
                                      if (controlNotifier.mediaPath.isEmpty) {
                                        scrollNotifier.pageController
                                            .animateToPage(
                                                1,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.ease);
                                      }
                                    },
                                    child: const CoverThumbnail(
                                      thumbnailQuality: 150,
                                    ),
                                  ))

                              /// return clear [imagePath] provider
                              : GestureDetector(
                                  onTap: () {
                                    /// clear image url variable
                                    controlNotifier.mediaPath = '';
                                    itemNotifier.draggableWidget.removeAt(0);
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    color: Colors.transparent,
                                    child: Transform.scale(
                                      scale: 0.7,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                if (controlNotifier.mediaPath.isEmpty &&
                    ((paintingProvider.lines.isEmpty &&
                        itemNotifier.draggableWidget.isEmpty)))
                  Flexible(
                      child: Column(
                    children: [
                      Text(
                        "Scroll Down For Media",
                        style: TextStyle(color: Colors.white, fontSize: 26.r),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.white,
                      )
                    ],
                  )),
                /*/// center logo
                if (controlNotifier.middleBottomWidget != null)
                  Expanded(
                    child: Center(
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: controlNotifier.middleBottomWidget),
                    ),
                  )
                else
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/instagram_logo.png',
                            package: 'stories_editor',
                            color: Colors.white,
                            height: 42,
                          ),
                          const Text(
                            'Stories Creator',
                            style: TextStyle(
                                color: Colors.white38,
                                letterSpacing: 1.5,
                                fontSize: 9.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
*/

                /// save final image to gallery
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: (paintingProvider.lines.isNotEmpty &&
                                  itemNotifier.draggableWidget.isNotEmpty &&
                                  controlNotifier.mediaPath.isNotEmpty)
                              ? () async {
                                  String pngUri;
                                  await takePicture(
                                          contentKey: contentKey,
                                          context: context,
                                          saveToGallery: false)
                                      .then((bytes) {
                                    if (bytes != null) {
                                      pngUri = bytes;
                                      Share.shareXFiles([XFile(pngUri)]);
                                    } else {}
                                  });
                                }
                              : null,
                          icon: Icon(
                            Icons.share,
                            color: (paintingProvider.lines.isNotEmpty ||
                                    itemNotifier.draggableWidget.isNotEmpty ||
                                    controlNotifier.mediaPath.isNotEmpty)
                                ? Colors.white
                                : Colors.black38,
                          )),
                      SizedBox(
                        width: 56.w,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: (paintingProvider
                                          .lines.isNotEmpty ||
                                      itemNotifier.draggableWidget.isNotEmpty ||
                                      controlNotifier.mediaPath.isNotEmpty)
                                  ? MaterialStatePropertyAll(Colors.white)
                                  : MaterialStatePropertyAll(Colors.grey)),
                          onPressed: (paintingProvider.lines.isNotEmpty &&
                                  itemNotifier.draggableWidget.isNotEmpty &&
                                  controlNotifier.mediaPath.isNotEmpty)
                              ? () async {
                                  String pngUri;
                                  await takePicture(
                                          contentKey: contentKey,
                                          context: context,
                                          saveToGallery: false)
                                      .then((bytes) {
                                    if (bytes != null) {
                                      pngUri = bytes;
                                      onDone(pngUri);
                                    } else {}
                                  });
                                }
                              : null,
                          child: Text(
                            "Done",
                            style: TextStyle(
                                color: (paintingProvider.lines.isNotEmpty ||
                                        itemNotifier
                                            .draggableWidget.isNotEmpty ||
                                        controlNotifier.mediaPath.isNotEmpty)
                                    ? Colors.green
                                    : Colors.black38),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }
}
