import 'package:flutter/material.dart';

class TextArea extends StatefulWidget {
  final String text;

  const TextArea({
    super.key,
    required this.text,
  });

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          splashColor: Colors.green,
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
                                widget.text,
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
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 80,
            height: 40,
            child: Center(
              child: Text(
                widget.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}