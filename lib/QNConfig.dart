/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:26:21 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:18:37
 */

part of qnsdk;

enum QNUnit {
  Kg,
  Lb,
  Jin,
  St,
}

class QNConfig {
  bool onlyScreenOn = false;
  bool allowDuplicates = false;
  int duration = 0;
  QNUnit unit = QNUnit.Kg;
  bool iOSShowPowerAlertKey = false;
  bool androidSetNotCheckGPS = false;
  int androidConnectOutTime = 10000;

  QNConfig(
      {this.onlyScreenOn = false,
      this.allowDuplicates = false,
      this.duration = 0,
      this.unit = QNUnit.Kg,
      this.iOSShowPowerAlertKey = false,
      this.androidSetNotCheckGPS = false,
      this.androidConnectOutTime = 10000});

  QNConfig.fromJson(Map params) {
    bool onlyScreenOn = params[ArgumentName.onlyScreenOn] ?? false;
    bool allowDuplicates = params[ArgumentName.allowDuplicates] ?? false;
    int duration = params[ArgumentName.duration] ?? 0;
    int androidConnectOutTime =
        params[ArgumentName.androidConnectOutTime] ?? 10000;
    QNUnit unit = QNUnit.Kg;
    switch (params[ArgumentName.unit] ?? 0) {
      case 1:
        unit = QNUnit.Lb;
        break;
      case 2:
        unit = QNUnit.Jin;
        break;
      case 3:
        unit = QNUnit.St;
        break;
      default:
        unit = QNUnit.Kg;
    }
    bool iOSShowPowerAlertKey =
        params[ArgumentName.iOSShowPowerAlertKey] ?? QNUnit.Kg;
    bool androidSetNotCheckGPS =
        params[ArgumentName.androidSetNotCheckGPS] ?? false;

    this.onlyScreenOn = onlyScreenOn;
    this.allowDuplicates = allowDuplicates;
    this.duration = duration;
    this.androidConnectOutTime = androidConnectOutTime;
    this.unit = unit;
    this.iOSShowPowerAlertKey = iOSShowPowerAlertKey;
    this.androidSetNotCheckGPS = androidSetNotCheckGPS;
  }

  Map<String, dynamic> getParams() {
    var parmas = <String, dynamic>{};
    parmas[ArgumentName.onlyScreenOn] = this.onlyScreenOn;
    parmas[ArgumentName.allowDuplicates] = this.allowDuplicates;
    parmas[ArgumentName.duration] = this.duration;
    parmas[ArgumentName.androidConnectOutTime] = this.androidConnectOutTime;
    parmas[ArgumentName.unit] = this.unit.index;
    parmas[ArgumentName.iOSShowPowerAlertKey] = this.iOSShowPowerAlertKey;
    parmas[ArgumentName.androidSetNotCheckGPS] = this.androidSetNotCheckGPS;
    return parmas;
  }
}
