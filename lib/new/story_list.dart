import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story/new/story_list_builder.dart';

import 'state/bloc/pagination/pagination_cubit.dart';

/// [Story] is the main, and and only widget you need to
/// archive pagination
class Story<T> extends StatelessWidget {
  /// [Story] is the main, and and only widget you need to
  /// archive pagination
  const Story(
      {super.key,
      this.scrollDirection = Axis.vertical,
      required this.onInit,
      required this.builder,
      required this.onLoad,
      this.padding,
      required this.rooContext,
      this.onInitialLoading,
      this.onLoadMoreLoading,
      this.topWidget,
      this.bottomWidget,
      this.onNoData,
      this.itemPadding,
      this.initPage = 1,
      this.myStory});

  final MyStory? myStory;
  final BuildContext rooContext;

  ///  [onInit] is a required argument for the [Story] widget.
  ///  It takes a function that will return [OnInit]
  /// [OnInit] can be `FutureOr<Iterable<T>>`
  /// This function will call on `initState` of [Story]'s life cycle
  final OnInit<T> onInit;

  /// [onLoad] is a required argument for the [Story] widget.
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

  /// padding for [Story] widget
  final EdgeInsetsGeometry? padding;

  /// padding for [Story] widget's items

  final EdgeInsetsGeometry? itemPadding;

  /// builder will [BuildContext] and `itemData` as a single item.
  /// and it will expect a widget that will represent a single item
  final ItemBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaginationCubit>(
        create: (BuildContext context) => PaginationCubit(),
        child: Navigator(onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) {
              return StoryList(
                rootContext: rooContext,
                onInit: onInit,
                builder: builder,
                myStory: myStory,
                onLoad: onLoad,
                padding: padding,
                scrollDirection: scrollDirection,
                bottomWidget: bottomWidget,
                initPage: initPage,
                itemPadding: padding,
                onInitialLoading: onInitialLoading,
                onLoadMoreLoading: onLoadMoreLoading,
                onNoData: onNoData,
                topWidget: topWidget,
              );
            },
          );
        }));
  }
}

class MyStory<T> {
  T storys;

  MyStory({required this.storys});
}

class StoryData<T> {
  Iterable<T> seen;
  Iterable<T> unseen;

  StoryData({required this.seen, required this.unseen});
}

/// type def for `onInit` argument of [Story]
typedef OnInit<T> = FutureOr<Iterable<StoryData<T>>> Function();

/// type def for `OnLoad` argument of [Story]
typedef OnLoad<T> = FutureOr<Iterable<StoryData<T>>> Function(int index);

/// type def for `builder` argument of [Story]
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, StoryData<T> itemData);
