import 'package:flutter/cupertino.dart';

class PeaDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> buttons;

  const PeaDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: buttons,
    );
  }
}
