/*
 * @Author: Yolanda 
 * @Date: 2020-02-19 14:05:43 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 15:50:45
 */

import 'package:flutter/widgets.dart';
import 'package:qnsdk_example/group/paddingText.dart';

class ScaleDataListItem extends StatefulWidget {
  final String title;
  final String value;

  ScaleDataListItem({required this.title, required this.value});
  @override
  _ScaleDataListItemState createState() => _ScaleDataListItemState();
}

class _ScaleDataListItemState extends State<ScaleDataListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(flex: 1, child: PaddingText(text: widget.title)),
          Expanded(
            flex: 1,
            child: PaddingText(text: widget.value, textAlign: TextAlign.right),
          )
        ],
      ),
    );
  }
}
