import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? spacing;
  final double? runSpacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final ScrollController? controller;

  final WrapAlignment? wrapAlignment;
  final WrapCrossAlignment? crossAxisAlignment;

  const HorizontalList({
    required this.itemCount,
    required this.itemBuilder,
    this.spacing,
    this.runSpacing,
    this.padding,
    this.physics,
    this.controller,
    this.reverse = false,
    this.wrapAlignment,
    this.crossAxisAlignment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding ?? const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      reverse: reverse,
      controller: controller,
      child: Wrap(
        spacing: spacing ?? 12,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        runAlignment: wrapAlignment ?? WrapAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
        children: List.generate(itemCount, (index) => itemBuilder(context, index)),
      ),
    );
  }
}