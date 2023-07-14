import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TextArea extends StatefulWidget {
  final String text;
  final TextStyle style;

  const TextArea(
    this.text, {
    super.key,
    required this.style,
  });

  @override
  createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  bool _isOverflowing = false;
  OverlayEntry? overlayEntry;

  String formattedText = '';

  @override
  void initState() {
    super.initState();

    final formatter = intl.NumberFormat('#,###,000');

    final parsedValue = int.tryParse(widget.text);

    formattedText = formatter.format(parsedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(10),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textSpan = TextSpan(
              text: formattedText,
              style: widget.style,
            );
          
            final textPainter = TextPainter(
              text: textSpan,
              maxLines: 1,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(maxWidth: constraints.maxWidth);
          
            final newOverflowState = textPainter.didExceedMaxLines;
            if (newOverflowState != _isOverflowing) {
              // Overflow state has changed
              _isOverflowing = newOverflowState;
            }
          
            if (_isOverflowing) {
              // Text overflowed
              return InkWell(
                splashColor: Colors.green,
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  if (overlayEntry != null) return; // Prevent creating multiple overlays

                  final RenderBox? button = context.findRenderObject() as RenderBox?;
                  final RenderBox? overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox?;
                  final buttonPosition = button?.localToGlobal(Offset.zero);
                  final overlayPosition = overlay?.localToGlobal(Offset.zero);
                  final buttonSize = button?.size;

                  if (buttonPosition != null && overlayPosition != null && buttonSize != null) {
                    final overlayPositionAdjusted = Offset(
                      buttonPosition.dx - overlayPosition.dx,
                      buttonPosition.dy - overlayPosition.dy,
                    );

                    // Create an overlay entry
                    overlayEntry = OverlayEntry(
                      builder: (context) {
                        return Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              overlayEntry?.remove();
                              overlayEntry = null;
                            },
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                                Positioned(
                                  left: overlayPositionAdjusted.dx - buttonSize.width / 2,
                                  top: overlayPositionAdjusted.dy + buttonSize.height / 2,
                                  child: Container(
                                    width: buttonSize.width * 2,
                                    padding: const EdgeInsets.all(12.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      formattedText,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    // Add the overlay entry to the overlay
                    Overlay.of(context)?.insert(overlayEntry!);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formattedText,
                    style: widget.style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }
          
            // Text fits within the available space
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                formattedText,
                // style: widget.style,
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
