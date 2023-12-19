import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story/new/state/bloc/pagination/pagination_cubit.dart';
import 'package:story/new/state/data.dart';
import 'package:story/story.dart';
import 'package:story_editor/stories_editor.dart';


/// [StoryList] is the main, and and only widget you need to
/// archive pagination
class StoryList<T> extends StatefulWidget {
  /// [StoryList] is the main, and and only widget you need to
  /// archive pagination
  const StoryList({
    super.key,
    this.scrollDirection = Axis.vertical,
    required this.onInit,
    required this.builder,
    required this.onLoad,
    required this.rootContext,
    this.padding,
    this.onInitialLoading,
    this.onLoadMoreLoading,
    this.topWidget,
    this.bottomWidget,
    this.onNoData,
    this.itemPadding,
    this.initPage = 1,
    this.myStory,
  });

  final BuildContext rootContext;

  final MyStory? myStory;

  ///  [onInit] is a required argument for the [StoryList] widget.
  ///  It takes a function that will return [OnInit]
  /// [OnInit] can be `FutureOr<Iterable<T>>`
  /// This function will call on `initState` of [StoryList]'s life cycle
  final OnInit<T> onInit;

  /// [onLoad] is a required argument for the [StoryList] widget.
  /// It takes a function that will return [OnLoad]
  /// [OnLoad] can be `FutureOr<Iterable<T>>`
  /// This function will call when the user reached to
  /// the end of the list of data
  final OnLoad<T> onLoad;

  /// [onInitialLoading] is a widget that will display until
  /// the initial data is loaded
  final Widget? onInitialLoading;

  /// [onLoadMoreLoading] is a widget at end of the list that will display
  /// when waiting for a response on a pagination API request
  final Widget? onLoadMoreLoading;
  final Axis scrollDirection;

  /// [onNoData] is a widget that will have no more data to display
  final Widget? onNoData;

  /// you can pass an additional widget that will display on top of the list
  final Widget? topWidget;

  /// you can pass an additional widget that will display on the bottom of
  /// the list
  final Widget? bottomWidget;

  /// [initPage] will take a [int] value representing the initial
  /// circle of requests. by default its is  `1`
  final int? initPage;

  /// padding for [StoryList] widget
  final EdgeInsetsGeometry? padding;

  /// padding for [StoryList] widget's items

  final EdgeInsetsGeometry? itemPadding;

  /// builder will [BuildContext] and `itemData` as a single item.
  /// and it will expect a widget that will represent a single item
  final ItemBuilder<T> builder;

  @override
  State<StoryList<T>> createState() => _StoryListState<T>();
}

class _StoryListState<T> extends State<StoryList<T>> {
  final scrollController = ScrollController();
  bool isLoading = false;

  int index = 0;
  bool isInitData = false;
  bool isNoData = false;

  Future<void> initData() async {
    final dataa = await widget.onInit();
    print(dataa.length);
    final paginationCubit = context.read<PaginationCubit>();
    paginationCubit.addData(
        data: dataa, pageIndex: index, myStory: widget.myStory?.storys);
    setState(() {
      isInitData = true;
    });
  }

  @override
  void initState() {
    final paginationCubit = context.read<PaginationCubit>();
    paginationCubit.addData(
        data: [],
        myStory: widget.myStory,
        pageIndex: widget.initPage != null ? widget.initPage! + 1 : 2);
    initData();
    scrollController.addListener(() async {
      if (isNoData == false) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          if (!mounted) return;

          setState(() {
            isLoading = true;
            print(isLoading);
          });
          final newData = await widget.onLoad(index++);
          if (newData.isEmpty) {
            setState(() {
              isNoData = true;
            });
          } else {
            final paginationCubit = context.read<PaginationCubit>();
            paginationCubit.addData(
                data: newData, pageIndex: index++, myStory: widget.myStory);
          }
          setState(() {
            isLoading = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollDirection == Axis.vertical)
      return ListView(
        controller: scrollController,
        children: [
          if (isInitData == false) widget.onInitialLoading ?? const SizedBox(),
          widget.topWidget ?? const SizedBox(),
          BlocConsumer<PaginationCubit, PaginationState>(
            listener: (context, state) {
              if (state is PaginationLoaded) {
                index = state.pageIndex;
                setState(() {});
              }
            },
            builder: (context, state) {
              if (state is PaginationLoaded<T>) {
                return ListView.builder(
                  padding: widget.padding,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: widget.itemPadding ?? EdgeInsets.zero,
                      child:
                          widget.builder(context, state.data.elementAt(index)),
                    );
                  },
                );
              }
              return SizedBox();
            },
          ),
          if (isLoading) widget.onLoadMoreLoading ?? const SizedBox(),
          if (isNoData) widget.onNoData ?? const SizedBox(),
          widget.bottomWidget ?? const SizedBox(),
        ],
      );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Wrap(
        spacing: 12,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          BlocConsumer<PaginationCubit, PaginationState>(
            listener: (context, state) {
              if (state is PaginationLoaded) {
                index = state.pageIndex;
                setState(() {});
              }
            },
            builder: (context, state) {
              if (state is PaginationLoaded) {
                print(state.data.length);
                print(state.myStory);
                Widget gg = Text('');

                if (state.myStory != null) {
                  gg = Stack(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              widget.rootContext,
                              MaterialPageRoute(
                                  builder: (context) =>  Scaffold(
                                      body: StoriesEditor(
                                        giphyKey: '6dSH8bdv9EkMosq7wdDwdeM8HepRsyG9',
                                        //fontFamilyList: const ['Shizuru', 'Aladin'],
                                        galleryThumbnailQuality: 300,
                                        //isCustomFontList: true,
                                        onDone: (uri) {
                                          debugPrint(uri);
                                        },
                                      ))),
                            );
                          },
                          icon: const Icon(Icons.edit))
                    ],
                  );
                }
                return Row(children: [
                  ...<Widget>[gg],
                  ...List.generate(state.data.length, (index) {
                    return Padding(
                      padding: widget.itemPadding ?? EdgeInsets.zero,
                      child: GestureDetector(
                          onTap: () {
                            print(index);
                          },
                          child: widget.builder(context,
                              state.data.elementAt(index) as StoryData<T>)),
                    );
                  })
                ]);
              }
              return SizedBox();
            },
          )
        ],
      ),
    );
  }
}
