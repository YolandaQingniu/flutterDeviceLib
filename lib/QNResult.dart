/*
 * @Author: Yolanda 
 * @Date: 2020-01-19 14:38:55 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:26:12
 */

part of qnsdk;

class QNResult {
  final int errorCode;
  final String? errorMsg;
  QNResult(this.errorCode, [this.errorMsg]);
}
