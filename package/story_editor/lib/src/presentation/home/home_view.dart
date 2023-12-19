import 'package:flutter/material.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_editor/src/domain/models/editable_items.dart';
import 'package:story_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:story_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:story_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:story_editor/src/presentation/main_view/main_view.dart';
import 'package:story_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:story_editor/src/presentation/widgets/HorizontalList.dart';
import 'package:story_editor/src/presentation/widgets/animated_onTap_button.dart';

class HomeView extends StatelessWidget {
   HomeView(
      {Key? key,
        required this.giphyKey,
        required this.onDone,
        this.middleBottomWidget,
        this.colorList,
        this.isCustomFontList,
        this.fontFamilyList,
        this.gradientColors,
        this.onBackPress,
        this.onDoneButtonStyle,
        this.editorBackgroundColor,
        this.galleryThumbnailQuality})
      : super(key: key);
  /// editor custom font families
  final List<String>? fontFamilyList;

  /// editor custom font families package
  final bool? isCustomFontList;

  /// giphy api key
  final String giphyKey;

  /// editor custom color gradients
  final List<List<Color>>? gradientColors;

  /// editor custom logo
  final Widget? middleBottomWidget;

  /// on done
  final Function(String)? onDone;

  /// on done button Text
  final Widget? onDoneButtonStyle;

  /// on back pressed
  final Future<bool>? onBackPress;

  /// editor background color
  final Color? editorBackgroundColor;

  /// gallery thumbnail quality
  final int? galleryThumbnailQuality;

  /// editor custom color palette list
  List<Color>? colorList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HorizontalList(
          itemCount: 12,
          itemBuilder: (context, index) => Container(
            height: 100,
            width: 60,
            color: Colors.red,
          ),
        ),
        Expanded(
          child: GalleryMediaPicker(
            mediaPickerParams: MediaPickerParamsModel(
              gridViewController: context.read<ScrollNotifier>().gridController,
              thumbnailQuality: 200,
              singlePick: true,
              onlyImages: true,
              maxPickImages: 1,
              appBarColor:
              Colors.black,
              gridViewPhysics: const ScrollPhysics(),
              appBarLeadingWidget: Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 15),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedOnTapButton(
                    onTap: () {
                    /*  scrollProvider.pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);*/
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.2,
                          )),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            pathList: (path) {
              if (path.isNotEmpty) {
                print(path.first.title);
                context.read<ControlNotifier>().mediaPath =
                    path.first.path.toString();
              }
              if (context.read<ControlNotifier>().mediaPath.isNotEmpty) {
                context.read<DraggableWidgetNotifier>().draggableWidget.insert(
                    0,
                    EditableItem()
                      ..type = ItemType.image
                      ..position = const Offset(0.0, 0));
              }

              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => MainView(
                    giphyKey: giphyKey,
                    onDone: onDone,
                    fontFamilyList: fontFamilyList,
                    isCustomFontList: isCustomFontList,
                    middleBottomWidget: middleBottomWidget,
                    gradientColors: gradientColors,
                    colorList: colorList,
                    onDoneButtonStyle: onDoneButtonStyle,
                    onBackPress: onBackPress,
                    editorBackgroundColor: editorBackgroundColor,
                    galleryThumbnailQuality: galleryThumbnailQuality,
                  )));
              /*scrollProvider.pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);*/
            },
          ),
        ),
      ],
    );
  }
}
