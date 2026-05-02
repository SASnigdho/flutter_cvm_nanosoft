import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CardWithTopTitle extends StatelessWidget {
  /// [CardWithTopTitle] is [StatelessWidget] widget show title text on top
  ///
  /// - `title` The text you want to display.
  /// - `titleStyle` Custom text style for title.
  /// - `body` Body take a widget to display.
  /// - `margin` The margin property of Container is used to set the margin.
  /// - `padding` The padding property of Container is used to set the padding.
  /// - `elevation` The shadow below the card.
  ///

  const CardWithTopTitle({
    super.key,
    this.title,
    this.titleStyle,
    required this.body,
    this.margin,
    this.padding,
    this.elevation,
    this.borderRadius,
  });

  final String? title;
  final TextStyle? titleStyle;
  final Widget body;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? elevation;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final titleTS = Theme.of(context).textTheme.headlineSmall!.copyWith(
      letterSpacing: .5,
      color: Theme.of(context).primaryColor,
    );

    final titleView = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(title ?? '', style: titleStyle ?? titleTS),
    );

    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Card(
        elevation: elevation ?? 5,
        margin: margin,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: (title != null) ? true : false,
                child: titleView,
              ),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
