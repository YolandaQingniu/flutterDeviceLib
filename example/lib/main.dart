import 'package:flutter/material.dart';
import 'package:qnsdk_example/bleTool.dart';
import 'package:qnsdk_example/group/deviceListItem.dart';
import 'package:qnsdk_example/group/paddingText.dart';
import 'package:qnsdk_example/group/scaleDataListItem.dart';
import 'package:qnsdk_example/tool/Toast.dart';
import 'package:qnsdk_example/userInfo.dart';
import 'package:qnsdk/qnsdk.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

enum EventState {
  Unknow,
  Scanning,
  Connecting,
  Connected,
  Unsteady,
  BodyFat,
  HeartRate,
  Completed,
  Disconnecting,
  Disconnected,
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _bleTool = BleTool();
  var _curEvent = EventState.Unknow;
  var _buttonText = 'start scan';
  var _stateText = 'pending';
  var _userInfoWidget = UserInfo();
  late QNBleDevice _curDevice;

  var _dataSource = <Map>[];
  var _deviceList = <QNBleDevice>[];

  @override
  void initState() {
    super.initState();
    _setBleStream();
  }

  void _setBleStream() {
    //QNBleStateListener
    _bleTool.bleStateStream.stream.listen((state) {
      var msg = "Unknown";
      switch (state) {
        case QNBLEState.Resetting:
          msg = 'resetting';
          break;
        case QNBLEState.Unsupported:
          msg = 'usupported';
          break;
        case QNBLEState.Unauthiorized:
          msg = 'unauthiorized';
          break;
        case QNBLEState.PoweredOff:
          msg = 'poweredOff';
          break;
        case QNBLEState.PoweredOn:
          msg = 'poweredOn';
          break;
        default:
      }
      Toast.showCenterToast(msg);
    });

    //QNBleConnectionChangeListener
    _bleTool.connectFailStream.stream.listen((value) {
      Toast.showCenterToast('connect fail');
    });

    //QNBleDeviceDiscoveryListener
    _bleTool.discoverStream.stream.listen((device) {
      for (var item in _deviceList) {
        if (item.mac == device.mac) {
          return;
        }
      }
      setState(() {
        _deviceList.add(device);
      });
    });

    //QNScaleDataListener
    _bleTool.unsteadyWeightStream.stream.listen((weight) {
      setState(() {
        _dataSource = [
          {
            'title': 'weight',
            'value': _bleTool.convertWeightWithTargetUnit(weight)
          }
        ];
      });
    });

    _bleTool.scaleDataStream.stream.listen((scaleData) {
      var result = <Map>[];
      for (var item in scaleData.allItemData) {
        var value;
        if (item.type == 1 ||
            item.type == 8 ||
            item.type == 12 ||
            item.type == 13) {
          value = _bleTool.convertWeightWithTargetUnit(item.value);
        } else {
          value = item.value.toStringAsFixed(2);
        }
        result.add({'title': item.name, 'value': value});
      }
      setState(() {
        _dataSource = result;
      });
    });

    _bleTool.storedDataStream.stream.listen((storedData) {
      var user = _userInfoWidget.user;
      _bleTool
          .generateScaleData(user, storedData.weight, storedData.measureTime,
              storedData.mac, storedData.hmac)
          .then((scaleData) {
        print('receive store data ${scaleData.toString()}');
      });
    });

    _bleTool.deviceStateStream.stream.listen((scaleState) {
      switch (scaleState) {
        case QNScaleState.STATE_Link_LOSS:
          _updateCurEvent(EventState.Unknow);
          break;
        case QNScaleState.STATE_DISCONNECTED:
          _updateCurEvent(EventState.Disconnected);
          break;
        case QNScaleState.STATE_CONNECTED:
          _updateCurEvent(EventState.Connected);
          break;
        case QNScaleState.STATE_CONNECTING:
          _updateCurEvent(EventState.Connecting);
          break;
        case QNScaleState.STATE_DISCONNECTING:
          _updateCurEvent(EventState.Disconnecting);
          break;
        case QNScaleState.STATE_START_MEASURE:
        case QNScaleState.STATE_REAL_TIME:
          _updateCurEvent(EventState.Unsteady);
          break;
        case QNScaleState.STATE_BODYFAT:
          _updateCurEvent(EventState.BodyFat);
          break;
        case QNScaleState.STATE_HEART_RATE:
          _updateCurEvent(EventState.HeartRate);
          break;
        case QNScaleState.STATE_MEASURE_COMPLETED:
          _updateCurEvent(EventState.Completed);
          break;
        default:
      }
    });
  }

  void _updateCurEvent(EventState state) {
    var curStateText = _stateText;
    var curBtnText = _buttonText;
    switch (state) {
      case EventState.Scanning:
        curStateText = 'scanning';
        curBtnText = 'stop scan';
        break;
      case EventState.Connecting:
        curStateText = 'connecting';
        curBtnText = 'stop connect';
        break;
      case EventState.Connected:
        curStateText = 'connected';
        curBtnText = 'stop connect';
        break;
      case EventState.Unsteady:
        curStateText = 'realtime weight';
        curBtnText = 'stop connect';
        break;
      case EventState.BodyFat:
        curStateText = 'measure bodyfat';
        curBtnText = 'stop connect';
        break;
      case EventState.HeartRate:
        curStateText = 'measure hear rate';
        curBtnText = 'stop connect';
        break;
      case EventState.Completed:
        curStateText = 'measure completed';
        curBtnText = 'stop connect';
        break;
      case EventState.Disconnecting:
        curStateText = 'disconnecting';
        curBtnText = 'start scan';
        break;
      case EventState.Disconnected:
        curStateText = 'pending';
        curBtnText = 'start scan';
        break;
      default:
        curStateText = 'pending';
        curBtnText = 'start scan';
    }
    setState(() {
      _curEvent = state;
      _stateText = curStateText;
      _buttonText = curBtnText;
    });
  }

  Future requestPermission() async {
    var permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      _bleTool.startScan();
      _updateCurEvent(EventState.Scanning);
    } else {
      Toast.showCenterToast(
          "Location permission is denied and bluetooth cannot find the device");
    }
  }

  void _curEventChange() {
    switch (_curEvent) {
      case EventState.Unknow:
        _deviceList.clear();
        if (Platform.isAndroid) {
          //request permission
          requestPermission();
        } else {
          _bleTool.startScan();
          _updateCurEvent(EventState.Scanning);
        }

        break;
      case EventState.Scanning:
        _bleTool.stopScan();
        _updateCurEvent(EventState.Unknow);
        break;
      case EventState.Connecting:
      case EventState.Connected:
      case EventState.Unsteady:
      case EventState.BodyFat:
      case EventState.HeartRate:
      case EventState.Completed:
        _bleTool.disConnect(_curDevice);
        _updateCurEvent(EventState.Unknow);
        break;
      default:
    }
  }

  void _connectDevice(QNBleDevice device) {
    _bleTool.stopScan();
    _updateCurEvent(EventState.Connecting);
    var user = _userInfoWidget.user;
    _curDevice = device;
    _bleTool.connect(device, user);
  }

  bool isShowDeviceList() {
    return _curEvent == EventState.Scanning ||
        _curEvent == EventState.Disconnected;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('SDK Demo'),
            ),
            body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    _userInfoWidget,
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: PaddingText(text: _buttonText),
                            onPressed: _curEventChange,
                          ),
                        )
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[PaddingText(text: _stateText)]),
                    Expanded(
                      flex: 1,
                      child: _showListView(),
                    )
                  ],
                ))));
  }

  Widget _showListView() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      itemCount: isShowDeviceList() ? _deviceList.length : _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        if (isShowDeviceList()) {
          var item = _deviceList[index];
          return GestureDetector(
            child: DeviceListItem(device: item),
            onTapUp: (details) {
              _connectDevice(_deviceList[index]);
            },
          );
        }
        Map item = _dataSource[index];
        return ScaleDataListItem(title: item['title'], value: item['value']);
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}
