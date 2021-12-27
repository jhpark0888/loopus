import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:loopus/widget/customlinkdialog.dart';

class CustomLinkStyleButton extends StatefulWidget {
  const CustomLinkStyleButton({
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.icon,
    this.iconTheme,
    this.dialogTheme,
    Key? key,
  }) : super(key: key);

  final QuillController controller;
  final IconData? icon;
  final double iconSize;
  final QuillIconTheme? iconTheme;
  final QuillDialogTheme? dialogTheme;

  @override
  _CustomLinkStyleButtonState createState() => _CustomLinkStyleButtonState();
}

class _CustomLinkStyleButtonState extends State<CustomLinkStyleButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant CustomLinkStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeSelection);
  }

  final GlobalKey _toolTipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = !widget.controller.selection.isCollapsed;
    final pressedHandler = isEnabled ? () => _openLinkDialog(context) : null;
    return GestureDetector(
      onTap: () async {
        final dynamic tooltip = _toolTipKey.currentState;
        tooltip.ensureTooltipVisible();
        Future.delayed(
          const Duration(
            seconds: 3,
          ),
          tooltip.deactivate,
        );
      },
      child: Tooltip(
        key: _toolTipKey,
        message: '영역을 선택해주세요.',
        child: QuillIconButton(
          highlightElevation: 0,
          hoverElevation: 0,
          size: widget.iconSize * kIconButtonFactor,
          icon: Icon(
            widget.icon ?? Icons.link,
            size: widget.iconSize,
            color: isEnabled
                ? (widget.iconTheme?.iconUnselectedColor ??
                    theme.iconTheme.color)
                : (widget.iconTheme?.disabledIconColor ?? theme.disabledColor),
          ),
          fillColor:
              widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor,
          onPressed: pressedHandler,
        ),
      ),
    );
  }

  void _openLinkDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return CustomLinkDialog(dialogTheme: widget.dialogTheme);
      },
    ).then(_linkSubmitted);
  }

  void _linkSubmitted(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    widget.controller.formatSelection(LinkAttribute(value));
  }
}
