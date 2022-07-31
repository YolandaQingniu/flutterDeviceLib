/*
 * @Author: Yolanda 
 * @Date: 2020-02-19 15:41:55 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:51:46
 */

import 'package:flutter/material.dart';

class PaddingText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double fontSize;
  final EdgeInsets insets;

  PaddingText(
      {required this.text,
      this.textAlign = TextAlign.start,
      this.fontSize = 17,
      this.insets = const EdgeInsets.fromLTRB(10, 0, 10, 0)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.insets,
      child: Text(
        this.text,
        style: TextStyle(fontSize: this.fontSize),
        textAlign: this.textAlign,
      ),
    );
  }
}
