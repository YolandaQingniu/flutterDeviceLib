/*
 * @Author: Yolanda 
 * @Date: 2020-02-18 16:19:37 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 17:46:29
 */

import 'package:flutter/material.dart';
import 'package:qnsdk_example/group/paddingText.dart';

class TitleInput extends StatefulWidget {
  final String text;
  final String initValue;
  final void Function(String)? textOnChange;
  final TextInputType inputType;

  TitleInput(
      {required this.text,
      required this.initValue,
      this.textOnChange,
      this.inputType = TextInputType.text});

  @override
  _TitleInputState createState() => _TitleInputState();
}

class _TitleInputState extends State<TitleInput> {
  TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editController.text = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PaddingText(text: widget.text),
          Expanded(
              child: TextField(
            controller: _editController,
            keyboardType: widget.inputType,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15)),
            maxLines: 1,
            onChanged: widget.textOnChange,
          ))
        ],
      ),
    );
  }
}
