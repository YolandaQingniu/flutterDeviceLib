/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:50:52 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 16:19:11
 */
/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:44:40 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-01-16 16:50:20
 */

part of qnsdk;

abstract class QNScaleState {
  static const int STATE_UNKNOWN = -99;
  static const int STATE_Link_LOSS = -1;
  static const int STATE_DISCONNECTED = 0;
  static const int STATE_CONNECTED = 1;
  static const int STATE_CONNECTING = 2;
  static const int STATE_DISCONNECTING = 3;
  static const int STATE_START_MEASURE = 5;
  static const int STATE_REAL_TIME = 6;
  static const int STATE_BODYFAT = 7;
  static const int STATE_HEART_RATE = 8;
  static const int STATE_MEASURE_COMPLETED = 9;
}

abstract class QNScaleDataListener {
  void onGetUnsteadyWeight(QNBleDevice device, double weight);

  void onGetScaleData(QNBleDevice device, QNScaleData data);

  void onGetStoredScale(
      QNBleDevice device, List<QNScaleStoreData> storedDataList);

  void onGetElectric(QNBleDevice device, int electric);

  void onScaleStateChange(QNBleDevice device, int scaleState);

  //qnsdkX-2.X
  void onScaleEventChange(QNBleDevice device, int scaleEvent);
}

class QNScaleDataListenerDump implements QNScaleDataListener {
  void onGetUnsteadyWeight(QNBleDevice device, double weight) {}

  void onGetScaleData(QNBleDevice device, QNScaleData data) {}

  void onGetStoredScale(
      QNBleDevice device, List<QNScaleStoreData> storedDataList) {}

  void onGetElectric(QNBleDevice device, int electric) {}

  void onScaleStateChange(QNBleDevice device, int scaleState) {}

  //qnsdkX-2.X
  void onScaleEventChange(QNBleDevice device, int scaleEvent) {}
}
