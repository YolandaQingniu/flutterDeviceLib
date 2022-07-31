/*
 * @Author: Yolanda 
 * @Date: 2020-01-16 16:04:21 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-19 15:25:59
 */

part of qnsdk;

class QNUser {
  final String userId;
  final int height;
  final String gender;
  final DateTime birthday;
  final int? athleteType;
  final double? clothesWeight;

  QNUser(this.userId, this.height, this.gender, this.birthday,
      [this.athleteType, this.clothesWeight]);

  QNUser.parse(Map params)
      : this(
            params[ArgumentName.userId],
            params[ArgumentName.height],
            params[ArgumentName.gender],
            DateTime.fromMillisecondsSinceEpoch(
                params[ArgumentName.birthday] ?? 0),
            params[ArgumentName.athleteType],
            params[ArgumentName.clothesWeight]);

  Map<String, dynamic> getParams() {
    var params = <String, dynamic>{};
    params['userId'] = this.userId;
    params['height'] = this.height;
    params['gender'] = this.gender;
    params['birthday'] = this.birthday.millisecondsSinceEpoch;
    params['athleteType'] = this.athleteType;
    params['clothesWeight'] = this.clothesWeight;
    return params;
  }
}
