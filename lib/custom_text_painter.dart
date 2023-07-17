import 'package:flutter/painting.dart';

class CustomTextPainter extends TextPainter {
  CustomTextPainter({
    required TextSpan text,
    TextAlign textAlign = TextAlign.left,
    double textScaleFactor = 1.0,
    TextDirection textDirection = TextDirection.ltr,
    Locale? locale,
    StrutStyle? strutStyle,
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
    TextHeightBehavior? textHeightBehavior,
  }) : super(
          text: text,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          textDirection: textDirection,
          locale: locale,
          strutStyle: strutStyle,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
        );

  @override
  void paint(Canvas canvas, Offset offset) {
    // Call the original TextPainter paint method to draw the text
    super.paint(canvas, offset);

    // Check if the text is overflowing
    if (didExceedMaxLines) {
      // Define the overflow symbol you want to use (in this case, a plus sign)
      const String overflowSymbol = '+';

      // Get the size of the overflow symbol
      final TextStyle textStyle = text!.style!;
      final TextSpan overflowTextSpan = TextSpan(text: overflowSymbol, style: textStyle);
      final TextPainter overflowTextPainter = TextPainter(
        text: overflowTextSpan,
        textDirection: textDirection,
      );
      overflowTextPainter.layout();

      // Calculate the position to draw the overflow symbol
      final double overflowX = offset.dx + size.width - overflowTextPainter.width;
      final double overflowY = offset.dy;

      // Draw the overflow symbol on the canvas
      overflowTextPainter.paint(canvas, Offset(overflowX, overflowY));
    }
  }
}
