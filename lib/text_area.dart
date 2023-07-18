import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TextArea extends StatefulWidget {
  final int score;
  final TextStyle style;

  const TextArea(
    this.score, {
    super.key,
    required this.style,
  });

  @override
  createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();

  String _formattedText = '';

  @override
  void initState() {
    super.initState();
    _formatScore();
  }

  void _formatScore() {
    final formatter = intl.NumberFormat('#,###', 'pt_BR');
    final formattedScore = formatter.format(widget.score);
    final suffix = (widget.score > 1) ? 'pts' : 'pt';

    _formattedText = '$formattedScore $suffix';
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  void _closeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  bool _isOverflowing(double width) {
    final textSpan = TextSpan(
      text: _formattedText,
      style: widget.style,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: width);
    
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(10),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const padding = EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            );
            final isOverflowing = _isOverflowing(
              constraints.maxWidth - padding.left - padding.right,
            );

            if (isOverflowing) {
              return InkWell(
                splashColor: Colors.green,
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  if (_overlayEntry != null) return; // Prevent creating multiple overlays

                  final RenderBox? button = context.findRenderObject() as RenderBox?;
                  final RenderBox? overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox?;
                  final buttonPosition = button?.localToGlobal(Offset.zero);
                  final overlayPosition = overlay?.localToGlobal(Offset.zero);
                  final buttonSize = button?.size;

                  if (buttonPosition != null && overlayPosition != null && buttonSize != null) {
                    _overlayEntry = OverlayEntry(
                      builder: (context) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _closeOverlay(),
                          child: Stack(
                            children: [
                              Positioned(
                                top: kToolbarHeight,
                                left: 0,
                                child: SafeArea(
                                  child: ClipRRect(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      child: CompositedTransformFollower(
                                        link: _layerLink,
                                        targetAnchor: Alignment.bottomCenter,
                                        followerAnchor: Alignment.bottomCenter,
                                        offset: const Offset(0, -20),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: buttonSize.width * 2,
                                            padding: const EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                _formattedText,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );

                    // Add the overlay entry to the overlay
                    Overlay.of(context)?.insert(_overlayEntry!);
                  }
                },
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: Padding(
                    padding: padding,
                    child: Text(
                      _formattedText,
                      style: widget.style.copyWith(color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: padding,
              child: Text(
                _formattedText,
                style: widget.style,
              ),
            );
          },
        ),
      ),
    );
  }
}
