/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 15:59:22 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:18:28
 */

part of qnsdk;

class QNBleDevice {
  final String mac;
  final String name;
  final String modeId;
  final String bluetoothName;
  final int rssi;
  final bool isScreenOn;

  QNBleDevice(this.mac, this.name, this.modeId, this.bluetoothName, this.rssi,
      this.isScreenOn);

  QNBleDevice.fromJson(Map params)
      : this(
            params[ArgumentName.mac],
            params[ArgumentName.name],
            params[ArgumentName.modeId],
            params[ArgumentName.bluetoothName],
            params[ArgumentName.rssi],
            params[ArgumentName.isScreenOn]);

  Map<String, dynamic> getParams() {
    var params = <String, dynamic>{};
    params[ArgumentName.mac] = this.mac;
    params[ArgumentName.modeId] = this.modeId;
    return params;
  }
}
