import 'package:flutter/material.dart';

class EllipsisText extends StatefulWidget {
  final String text;
  final int maxLines;

  const EllipsisText({required this.text, required this.maxLines, super.key});

  @override
  State<EllipsisText> createState() => _EllipsisTextState();
}

class _EllipsisTextState extends State<EllipsisText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: DefaultTextStyle.of(context).style,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.text,
                  textAlign: TextAlign.justify,
                  maxLines: isExpanded ? null : widget.maxLines,
                  overflow: isExpanded ? null : TextOverflow.fade,
                ),
                isExpanded
                    ? const SizedBox.shrink()
                    : Text(
                        '...Read more',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
              ],
            ),
          );
        } else {
          return Text(
            widget.text,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}
