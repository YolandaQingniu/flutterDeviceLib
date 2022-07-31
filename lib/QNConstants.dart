/*
 * @Author: Yolanda 
 * @Date: 2020-02-11 16:37:22 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-15 13:54:17
 */

abstract class MethodName {
  static const String initSdk = "flutter_initSdk";
  static const String setBleStateListener = "flutter_setBleStateListener";
  static const String setBleDeviceDiscoveryListener =
      "flutter_setBleDeviceDiscoveryListener";
  static const String startBleDeviceDiscovery =
      "flutter_startBleDeviceDiscovery";
  static const String stopBleDeviceDiscovery = "flutter_stopBleDeviceDiscovery";
  static const String connectDevice = "flutter_connectDevice";
  static const String disconnectDevice = "flutter_disconnectDevice";
  static const String setBleConnectionChangeListener =
      "flutter_setBleConnectionChangeListener";
  static const String setScaleDataListener = "flutter_setScaleDataListener";
  static const String getConfig = "flutter_getConfig";
  static const String saveConfig = "flutter_saveConfig";
  static const String convertWeightWithTargetUnit =
      "flutter_convertWeightWithTargetUnit";
  static const String generateScaleData = "flutter_generateScaleData";
}

abstract class EventName {
  static const String onBleSystemState = "flutter_onBleSystemState";
  static const String onGetUnsteadyWeight = "flutter_onGetUnsteadyWeight";
  static const String onGetScaleData = "flutter_onGetScaleData";
  static const String onGetStoredScale = "flutter_onGetStoredScale";
  static const String onGetElectric = "flutter_onGetElectric";
  static const String onScaleStateChange = "flutter_onScaleStateChange";
  static const String onDeviceDiscover = "flutter_onDeviceDiscover";
  static const String onStartScan = "flutter_onStartScan";
  static const String onStopScan = "flutter_onStopScan";
  static const String onScanFail = "flutter_onScanFail";
  static const String onConnecting = "flutter_onConnecting";
  static const String onConnected = "flutter_onConnected";
  static const String onServiceSearchComplete =
      "flutter_onServiceSearchComplete";
  static const String onDisconnecting = "flutter_onDisconnecting";
  static const String onDisconnected = "flutter_onDisconnected";
  static const String onConnectError = "flutter_onConnectError";

  //qnsdkX-2.x
  static const String onScaleEventChange = "flutter_onScaleEventChange";
}

abstract class ArgumentName {
  static const String channelName = "yolanda.flutter.io/channe";
  static const String eventName = "yolanda.flutter.io/event";
  static const String methodName = "method";

  static const String errorCode = "errorCode";
  static const String errorMsg = "errorMsg";

  static const String device = "device";
  static const String mac = "mac";
  static const String name = "name";
  static const String modeId = "modeId";
  static const String bluetoothName = "bluetoothName";
  static const String rssi = "rssi";
  static const String isScreenOn = "isScreenOn";

  static const String onlyScreenOn = "onlyScreenOn";
  static const String allowDuplicates = "allowDuplicates";
  static const String duration = "duration";
  static const String unit = "unit";
  static const String iOSShowPowerAlertKey = "iOSShowPowerAlertKey";
  static const String androidConnectOutTime = "androidConnectOutTime";
  static const String androidSetNotCheckGPS = "androidSetNotCheckGPS";

  static const String scaleData = "scaleData";
  static const String user = "user";
  static const String measureTime = "measureTime";
  static const String hmac = "hmac";
  static const String allItemData = "allItemData";

  static const String type = "type";
  static const String value = "value";
  static const String valueType = "valueType";

  static const String weight = "weight";

  static const String userId = "userId";
  static const String height = "height";
  static const String gender = "gender";
  static const String birthday = "birthday";
  static const String athleteType = "athleteType";
  static const String clothesWeight = "clothesWeight";

  static const String appid = "appid";
  static const String fileContent = "fileContent";

  static const String state = "state";
  static const String data = "data";
  static const String storedDataList = "storedDataList";
  static const String electric = "electric";
  static const String scaleState = "scaleState";

  static const String scanFailCode = "scanFailCode";

  //qnsdkX-2.X
  static const String scaleEvent = "scaleEvent";
}
