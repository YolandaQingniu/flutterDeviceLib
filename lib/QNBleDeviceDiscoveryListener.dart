/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:54:25 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:25:19
 */

part of qnsdk;

abstract class QNBleDeviceDiscoveryListener {
  void onDeviceDiscover(QNBleDevice device);

  void onStartScan();

  void onStopScan();

  void onScanFail(int code);
}

class QNBleDeviceDiscoveryListenerDump implements QNBleDeviceDiscoveryListener {
  void onDeviceDiscover(QNBleDevice device) {}

  void onStartScan() {}

  void onStopScan() {}

  void onScanFail(int code) {}
}
