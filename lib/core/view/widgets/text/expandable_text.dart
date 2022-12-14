import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/widgets/auto_direction/auto_direction.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key? key,
    this.trimLines = 2,
    this.color,
  });

  final String text;
  final int trimLines;
  final Color? color;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final colorClickableText = Colors.blue;
    final widgetColor = widget.color ?? Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? " ${'read more'.tr}..." : "",
        style: TextStyle(
          fontSize: 16.5,
          color: colorClickableText,
          fontFamily: 'Arial',
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        /// Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );

        /// Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        /// Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        /// Get the endIndex of data
        int? endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: TextStyle(
              fontSize: 16.5,
              fontFamily: 'Arial',
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: TextStyle(
              fontSize: 16.5,
              fontFamily: 'Arial',
              color: widgetColor,
            ),
          );
        }

        return GestureDetector(
          onTap: _onTapLink,
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.clip,
            text: textSpan,
          ),
        );
      },
    );

    return AutoDirection(
      text: widget.text,
      child: result,
    );
  }
}
