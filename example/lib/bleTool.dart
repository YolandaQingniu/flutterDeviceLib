/*
 * @Author: Yolanda 
 * @Date: 2020-02-19 16:33:53 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 17:46:10
 */

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qnsdk/qnsdk.dart';

class BleTool
    implements
        QNBleStateListener,
        QNBleDeviceDiscoveryListener,
        QNBleConnectionChangeListener,
        QNScaleDataListener {
  var qnApi = QNApi();
  StreamController<QNBLEState> bleStateStream = StreamController();
  StreamController<QNBleDevice> discoverStream = StreamController();
  StreamController<double> unsteadyWeightStream = StreamController();
  StreamController<QNScaleData> scaleDataStream = StreamController();
  StreamController<QNScaleStoreData> storedDataStream = StreamController();
  StreamController<int> deviceStateStream = StreamController();
  StreamController connectFailStream = StreamController();

  QNUnit curUnit = QNUnit.Lb;

  BleTool() {
    _initQnSdk();
  }

  void startScan() {
    qnApi.startBleDeviceDiscovery().then((result) {
      print("startBleDeviceDiscovery ${result.errorCode}");
    });
  }

  void stopScan() {
    qnApi.stopBleDeviceDiscovery().then((result) {
      print("stopBleDeviceDiscovery ${result.errorCode}");
    });
  }

  void connect(QNBleDevice device, QNUser user) {
    qnApi.connectDevice(device, user).then((result) {
      print("connectDevice ${result.errorCode}");
      if (result.errorCode != 0) {
        //Please handle the error by yourself
      }
    });
  }

  void disConnect(QNBleDevice device) {
    qnApi.disconnectDevice(device);
  }

  String convertWeightWithTargetUnit(double weight) {
    double result = qnApi.convertWeightWithTargetUnit(weight, curUnit);

    if (curUnit == QNUnit.Jin) {
      return "${result.toStringAsFixed(2)} 斤";
    } else if (curUnit == QNUnit.Lb) {
      return "${result.toStringAsFixed(2)} lb";
    } else if (curUnit == QNUnit.St) {
      int stNum = result ~/ 14;
      return "${stNum} st ${result - stNum} lb";
    } else {
      return "${result.toStringAsFixed(2)} kg";
    }
  }

  Future<QNScaleData> generateScaleData(QNUser user, double weight,
      DateTime measureTime, String mac, String hmac) async {
    return qnApi.generateScaleData(user, weight, measureTime, mac, hmac);
  }

  void _initQnSdk() async {
    await _setSdkConfig();

    String configFileContent = await rootBundle.loadString('data/123456789.qn');
    qnApi
        .initSDK('123456789', configFileContent)
        .then((result) => print('initSDK ${result.errorCode}'));

    _setListener();
  }

  void _setListener() async {
    qnApi
        .setBleStateListener(this)
        .then((result) => print('setBleStateListener ${result.errorCode}'));
    qnApi.setBleDeviceDiscoveryListener(this).then(
        (result) => print('setBleDeviceDiscoveryListener ${result.errorCode}'));
    qnApi.setBleConnectionChangeListener(this).then((result) =>
        print('setBleConnectionChangeListener ${result.errorCode}'));
    qnApi
        .setScaleDataListener(this)
        .then((result) => print('setScaleDataListener ${result.errorCode}'));
  }

  Future<void> _setSdkConfig() async {
    var config = QNConfig(
        allowDuplicates: true, iOSShowPowerAlertKey: true, unit: curUnit);
    qnApi.saveConfig(config);
  }

  // QNBleStateListener
  @override
  void onBleSystemState(QNBLEState state) {
    bleStateStream.add(state);
  }

  //QNBleDeviceDiscoveryListener
  @override
  void onDeviceDiscover(QNBleDevice device) {
    discoverStream.add(device);
  }

  @override
  void onStartScan() {}

  @override
  void onStopScan() {}

  @override
  void onScanFail(int code) {}

  //QNBleConnectionChangeListener
  @override
  void onConnecting() {
    //deviceStateStream.add(QNScaleState.STATE_CONNECTING);
  }

  @override
  void onConnected() {
    deviceStateStream.add(QNScaleState.STATE_CONNECTED);
  }

  @override
  void onServiceSearchComplete() {}

  @override
  void onDisconnecting() {
    //deviceStateStream.add(QNScaleState.STATE_DISCONNECTING);
  }

  @override
  void onDisconnected() {
    deviceStateStream.add(QNScaleState.STATE_DISCONNECTED);
  }

  @override
  void onConnectError(int errorCode) {
    connectFailStream.add(true);
  }

  //QNScaleDataListener
  @override
  void onGetUnsteadyWeight(QNBleDevice device, double weight) {
    unsteadyWeightStream.add(weight);
  }

  @override
  void onGetScaleData(QNBleDevice device, QNScaleData data) {
    scaleDataStream.add(data);
  }

  @override
  void onGetStoredScale(
      QNBleDevice device, List<QNScaleStoreData> storedDataList) {
    for (var item in storedDataList) {
      storedDataStream.add(item);
    }
  }

  @override
  void onGetElectric(QNBleDevice device, int electric) {}

  @override
  void onScaleStateChange(QNBleDevice device, int scaleState) {
    deviceStateStream.add(scaleState);
  }

  @override
  void onScaleEventChange(QNBleDevice device, int saleEvent) {}
}
