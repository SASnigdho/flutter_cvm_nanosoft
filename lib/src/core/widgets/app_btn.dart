import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppBtn extends StatelessWidget {
  const AppBtn(
    this.title, {
    super.key,
    this.tap,
    this.color,
    this.gradient,
    this.border,
    this.textStyle,
    this.prefixIcon,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.margin,
  });

  final String title;
  final VoidCallback? tap;
  final Color? color;
  final Gradient? gradient;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final double? height;
  final double? width;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final decoration =
        this.decoration ??
        BoxDecoration(
          color: color ?? const Color(0xFFB8B3AC),
          gradient:
              gradient ??
              (color == null
                  ? (tap == null ? null : AppColors.linearGradient)
                  : null),
          borderRadius: BorderRadius.circular(12),
          border: border,
        );

    final buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
      overlayColor: WidgetStateColor.resolveWith(
        (states) => Colors.transparent,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
    );

    final TextStyle? textStyle =
        this.textStyle ??
        Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: AppColors.white);

    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: TextButton(
        onPressed: tap,
        style: buttonStyle,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (prefixIcon != null) const SizedBox(width: 16),
            ?prefixIcon,
            Expanded(
              child: Text(title, textAlign: TextAlign.center, style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
