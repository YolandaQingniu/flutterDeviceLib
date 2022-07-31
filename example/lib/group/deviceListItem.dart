/*
 * @Author: Yolanda 
 * @Date: 2020-02-20 09:03:34 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 15:03:51
 */

import 'package:flutter/material.dart';
import 'package:qnsdk/qnsdk.dart';
import 'package:qnsdk_example/group/paddingText.dart';

class DeviceListItem extends StatefulWidget {
  final QNBleDevice device;

  DeviceListItem({required this.device});

  @override
  _DeviceListItemState createState() => _DeviceListItemState();
}

class _DeviceListItemState extends State<DeviceListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PaddingText(text: widget.device.name),
          PaddingText(text: widget.device.modeId, insets: EdgeInsets.zero),
          PaddingText(text: widget.device.rssi.toString()),
          Expanded(
              flex: 1,
              child:
                  PaddingText(text: widget.device.mac, insets: EdgeInsets.zero))
        ],
      ),
    );
  }
}
