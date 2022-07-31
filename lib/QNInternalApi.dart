/*
 * @Author: Yolanda 
 * @Date: 2020-02-12 11:44:12 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 17:45:36
 */
part of qnsdk;

class QNInternalApi implements QNApi {
  QNBleDeviceDiscoveryListener _discoveryListener =
      QNBleDeviceDiscoveryListenerDump();
  QNBleConnectionChangeListener _connectionChangeListener =
      QNBleConnectionChangeListenerDump();
  QNScaleDataListener _scaleDataListener = QNScaleDataListenerDump();
  QNBleStateListener _bleStateListener = QNBleStateListenerDump();

  final MethodChannel _methodChannel =
      const MethodChannel(ArgumentName.channelName);
  final EventChannel _eventChannel = const EventChannel(ArgumentName.eventName);

  QNInternalApi() {
    _eventChannel.receiveBroadcastStream().listen((message) {
      Map data = message[ArgumentName.data];
      String eventName = message[ArgumentName.methodName];
      switch (eventName) {
        case EventName.onBleSystemState:
          _onBleSystemState(data);
          break;
        case EventName.onGetUnsteadyWeight:
          _onGetUnsteadyWeight(data);
          break;
        case EventName.onGetScaleData:
          _onGetScaleData(data);
          break;
        case EventName.onGetStoredScale:
          _onGetStoredScale(data);
          break;
        case EventName.onGetElectric:
          _onGetElectric(data);
          break;
        case EventName.onScaleStateChange:
          _onScaleStateChange(data);
          break;
        case EventName.onDeviceDiscover:
          _onDeviceDiscover(data);
          break;
        case EventName.onStartScan:
          _onStartScan(data);
          break;
        case EventName.onStopScan:
          _onStopScan(data);
          break;
        case EventName.onScanFail:
          _onScanFail(data);
          break;
        case EventName.onConnecting:
          _onConnecting(data);
          break;
        case EventName.onConnected:
          _onConnected(data);
          break;
        case EventName.onServiceSearchComplete:
          _onServiceSearchComplete(data);
          break;
        case EventName.onDisconnecting:
          _onDisconnecting(data);
          break;
        case EventName.onDisconnected:
          _onDisconnected(data);
          break;
        case EventName.onConnectError:
          _onConnectError(data);
          break;
        //qnsdkX-2.x
        case EventName.onScaleEventChange:
          _onScaleEventChange(data);
          break;

        default:
      }
    }, onError: (err) {});
  }

  Future<QNResult> _callMethod(
      {required String methodName, Map? params}) async {
    Map<String, dynamic>? result =
        await _methodChannel.invokeMapMethod(methodName, params);
    return QNResult(
        result![ArgumentName.errorCode], result[ArgumentName.errorMsg]);
  }

  //QNBleStateListener
  void _onBleSystemState(Map data) {
    int state = data[ArgumentName.state];
    var bleState = QNBLEState.Unknown;
    switch (state) {
      case 1:
        bleState = QNBLEState.Resetting;
        break;
      case 2:
        bleState = QNBLEState.Unsupported;
        break;
      case 3:
        bleState = QNBLEState.Unauthiorized;
        break;
      case 4:
        bleState = QNBLEState.PoweredOff;
        break;
      case 5:
        bleState = QNBLEState.PoweredOn;
        break;
      default:
    }
    _bleStateListener.onBleSystemState(bleState);
  }

  //QNBleDeviceDiscoveryListener
  void _onDeviceDiscover(Map params) {
    Map deviceJson = params[ArgumentName.device];
    var device = QNBleDevice.fromJson(deviceJson);
    _discoveryListener.onDeviceDiscover(device);
  }

  void _onStartScan(Map params) => _discoveryListener.onStartScan();

  void _onStopScan(Map params) => _discoveryListener.onStopScan();

  void _onScanFail(Map params) =>
      _discoveryListener.onScanFail(params[ArgumentName.scanFailCode]);

  //QNBleConnectionChangeListener
  void _onConnecting(Map params) => _connectionChangeListener.onConnecting();

  void _onConnected(Map params) => _connectionChangeListener.onConnected();

  void _onServiceSearchComplete(Map params) =>
      _connectionChangeListener.onServiceSearchComplete();

  void _onDisconnecting(Map params) =>
      _connectionChangeListener.onDisconnecting();

  void _onDisconnected(Map params) =>
      _connectionChangeListener.onDisconnected();

  void _onConnectError(Map params) =>
      _connectionChangeListener.onConnectError(params[ArgumentName.errorCode]);

  //QNScaleDataListener
  void _onGetUnsteadyWeight(Map params) {
    double weight = params[ArgumentName.weight] ?? 0;
    var device = QNBleDevice.fromJson(params[ArgumentName.device]);
    _scaleDataListener.onGetUnsteadyWeight(device, weight);
  }

  void _onGetScaleData(Map params) {
    var device = QNBleDevice.fromJson(params[ArgumentName.device]);
    var scaleData = QNScaleData.fromJson(params[ArgumentName.scaleData]);
    _scaleDataListener.onGetScaleData(device, scaleData);
  }

  void _onGetStoredScale(Map params) {
    var device = QNBleDevice.fromJson(params[ArgumentName.device]);
    var storeDataList = <QNScaleStoreData>[];
    List storeDataListJson = params[ArgumentName.storedDataList];
    for (var item in storeDataListJson) {
      storeDataList.add(QNScaleStoreData.fromJson(item));
    }
    _scaleDataListener.onGetStoredScale(device, storeDataList);
  }

  void _onGetElectric(Map params) {
    var device = QNBleDevice.fromJson(params[ArgumentName.device]);
    int electric = params[ArgumentName.electric];
    _scaleDataListener.onGetElectric(device, electric);
  }

  void _onScaleStateChange(Map params) {
    var device = QNBleDevice.fromJson(params[ArgumentName.device]);
    int scaleStateIndex = params[ArgumentName.scaleState] ?? 0;
    int state = QNScaleState.STATE_UNKNOWN;
    switch (scaleStateIndex) {
      case -1:
        state = QNScaleState.STATE_Link_LOSS;
        break;
      case 0:
        state = QNScaleState.STATE_DISCONNECTED;
        break;
      case 1:
        state = QNScaleState.STATE_CONNECTED;
        break;
      case 2:
        state = QNScaleState.STATE_CONNECTING;
        break;
      case 3:
        state = QNScaleState.STATE_DISCONNECTING;
        break;
      case 5:
        state = QNScaleState.STATE_START_MEASURE;
        break;
      case 6:
        state = QNScaleState.STATE_REAL_TIME;
        break;
      case 7:
        state = QNScaleState.STATE_BODYFAT;
        break;
      case 8:
        state = QNScaleState.STATE_HEART_RATE;
        break;
      case 9:
        state = QNScaleState.STATE_MEASURE_COMPLETED;
        break;
    }
    if (state != QNScaleState.STATE_UNKNOWN) {
      _scaleDataListener.onScaleStateChange(device, state);
    }
  }

  //qnsdkX-2.x
  void _onScaleEventChange(Map params) {
    var device = QNBleDevice.fromJson(params[ArgumentName.device]);
    int scaleEvent = params[ArgumentName.scaleEvent];
    _scaleDataListener.onGetElectric(device, scaleEvent);
  }

  @override
  Future<QNResult> initSDK(String appid, String fileContent) async {
    Map<String, String> params = <String, String>{};
    params[ArgumentName.appid] = appid;
    params[ArgumentName.fileContent] = fileContent;
    return _callMethod(methodName: MethodName.initSdk, params: params);
  }

  @override
  Future<QNResult> setBleStateListener(QNBleStateListener listener) async {
    QNResult result =
        await _callMethod(methodName: MethodName.setBleStateListener);
    if (result.errorCode == 0) {
      _bleStateListener = listener;
    }
    return result;
  }

  @override
  Future<QNResult> setBleDeviceDiscoveryListener(
      QNBleDeviceDiscoveryListener listener) async {
    QNResult result =
        await _callMethod(methodName: MethodName.setBleDeviceDiscoveryListener);
    if (result.errorCode == 0) {
      _discoveryListener = listener;
    }
    return result;
  }

  @override
  Future<QNResult> setBleConnectionChangeListener(
      QNBleConnectionChangeListener listener) async {
    QNResult result = await _callMethod(
        methodName: MethodName.setBleConnectionChangeListener);
    if (result.errorCode == 0) {
      _connectionChangeListener = listener;
    }
    return result;
  }

  @override
  Future<QNResult> setScaleDataListener(QNScaleDataListener listener) async {
    QNResult result =
        await _callMethod(methodName: MethodName.setScaleDataListener);
    if (result.errorCode == 0) {
      _scaleDataListener = listener;
    }
    return result;
  }

  @override
  Future<QNResult> startBleDeviceDiscovery() async =>
      _callMethod(methodName: MethodName.startBleDeviceDiscovery);

  @override
  Future<QNResult> stopBleDeviceDiscovery() async =>
      _callMethod(methodName: MethodName.stopBleDeviceDiscovery);

  @override
  Future<QNResult> connectDevice(QNBleDevice device, QNUser user) async {
    Map<String, Map> params = <String, Map>{};
    params[ArgumentName.device] = device.getParams();
    params[ArgumentName.user] = user.getParams();
    return _callMethod(methodName: MethodName.connectDevice, params: params);
  }

  @override
  Future<QNResult> disconnectDevice(QNBleDevice device) async {
    return _callMethod(
        methodName: MethodName.disconnectDevice, params: device.getParams());
  }

  @override
  Future<QNConfig> getConfig() async {
    Map<String, dynamic>? result =
        await _methodChannel.invokeMapMethod(MethodName.getConfig);
    return QNConfig.fromJson(result!);
  }

  @override
  Future<QNResult> saveConfig(QNConfig config) async => _callMethod(
      methodName: MethodName.saveConfig, params: config.getParams());

  @override
  double convertWeightWithTargetUnit(double weight, QNUnit unit) {
    double result = weight;
    switch (unit) {
      case QNUnit.Lb:
      case QNUnit.St:
        result = ((((weight * 100) * 11023 + 50000) ~/ 100000) << 1) / 10.0;
        break;
      case QNUnit.Jin:
        result = weight * 2;
        break;
      default:
    }
    return result;
  }

  @override
  Future<QNScaleData> generateScaleData(QNUser user, double weight,
      DateTime measureTime, String mac, String hmac) async {
    var params = <String, dynamic>{};
    params[ArgumentName.user] = user.getParams();
    params[ArgumentName.measureTime] = measureTime.millisecondsSinceEpoch;
    params[ArgumentName.mac] = mac;
    params[ArgumentName.hmac] = hmac;
    params[ArgumentName.weight] = weight;

    Map<String, dynamic>? result = await _methodChannel.invokeMapMethod(
        MethodName.generateScaleData, params);

    List<QNScaleItemData> allItemData = <QNScaleItemData>[];
    List allItemDataMap = result![ArgumentName.allItemData];

    for (var item in allItemDataMap) {
      QNScaleItemData itemData = QNScaleItemData(
          item[ArgumentName.type],
          item[ArgumentName.value],
          item[ArgumentName.valueType],
          item[ArgumentName.name]);
      allItemData.add(itemData);
    }

    return QNScaleData(
        user, measureTime, result[ArgumentName.hmac], allItemData);
  }
}
