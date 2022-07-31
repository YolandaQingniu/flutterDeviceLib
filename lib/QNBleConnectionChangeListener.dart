/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:51:18 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:18:10
 */

part of qnsdk;

abstract class QNBleConnectionChangeListener {
  void onConnecting();

  void onConnected();

  void onServiceSearchComplete();

  void onDisconnecting();

  void onDisconnected();

  void onConnectError(int errorCode);
}

class QNBleConnectionChangeListenerDump
    implements QNBleConnectionChangeListener {
  void onConnecting() {}

  void onConnected() {}

  void onServiceSearchComplete() {}

  void onDisconnecting() {}

  void onDisconnected() {}

  void onConnectError(int errorCode) {}
}
