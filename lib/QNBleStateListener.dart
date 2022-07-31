/*
 * @Author: Yolanda 
 * @Date: 2020-01-19 14:01:01 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:18:33
 */

part of qnsdk;

enum QNBLEState {
  Unknown,
  Resetting,
  Unsupported,
  Unauthiorized,
  PoweredOff,
  PoweredOn,
}

abstract class QNBleStateListener {
  void onBleSystemState(QNBLEState state);
}

class QNBleStateListenerDump implements QNBleStateListener {
  void onBleSystemState(QNBLEState state) {}
}
