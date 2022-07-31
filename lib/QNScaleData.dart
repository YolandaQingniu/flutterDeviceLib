/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:11:48 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 15:15:46
 */

part of qnsdk;

class QNScaleData {
  late QNUser user;
  late DateTime measureTime;
  late String hmac;
  late List<QNScaleItemData> allItemData;

  QNScaleData(this.user, this.measureTime, this.hmac, this.allItemData);

  QNScaleData.fromJson(Map params) {
    this.user = QNUser.parse(params[ArgumentName.user]);
    int milliTime = params[ArgumentName.measureTime] ?? 0;
    this.measureTime = DateTime.fromMillisecondsSinceEpoch(milliTime);
    this.hmac = params[ArgumentName.hmac];

    this.allItemData = <QNScaleItemData>[];
    List allItemDataMap = params[ArgumentName.allItemData];
    for (var item in allItemDataMap) {
      QNScaleItemData itemData = QNScaleItemData.fromJson(item);
      this.allItemData.add(itemData);
    }
  }
}
