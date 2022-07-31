/*
 * @Author: Yolanda 
 * @Date: 2020-02-19 15:57:20 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 16:38:07
 */

import 'package:flutter/material.dart';
import 'package:qnsdk_example/group/paddingText.dart';
import 'package:qnsdk_example/group/titleInput.dart';
import 'package:qnsdk/qnsdk.dart';

class UserInfoModel {
  String userId = '1234567';
  int height = 170;
  String gender = 'male';
  bool athleteType = false;
  double clothesWeight = 0;
  DateTime birthday = DateTime(1990, 1, 1);

  QNUser get user => QNUser(
      userId, height, gender, birthday, athleteType ? 1 : 0, clothesWeight);
}

class UserInfo extends StatefulWidget {
  final userinfomodel = UserInfoModel();

  QNUser get user => userinfomodel.user;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        userIdAndHeight(),
        genderAndSport(),
        birthdayAndClothesWeight()
      ],
    );
  }

  Widget userIdAndHeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(
                text: 'userId',
              ),
              PaddingText(text: widget.userinfomodel.userId)
            ],
          ),
        ),
        Expanded(
            flex: 1,
            child: TitleInput(
                text: 'height',
                initValue: widget.userinfomodel.height.toString(),
                textOnChange: (value) {
                  if (value != null) {
                    setState(() {
                      widget.userinfomodel.height = int.parse(value);
                    });
                  }
                },
                inputType: TextInputType.number)),
      ],
    );
  }

  Widget genderAndSport() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(text: 'gender'),
              Radio(
                  groupValue: widget.userinfomodel.gender,
                  value: 'male',
                  onChanged: (value) {
                    setState(() {
                      widget.userinfomodel.gender = value as String;
                    });
                  }),
              Radio(
                  groupValue: widget.userinfomodel.gender,
                  value: 'female',
                  onChanged: (value) {
                    setState(() {
                      widget.userinfomodel.gender = value as String;
                    });
                  })
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(text: 'athleteType'),
              Switch(
                  value: widget.userinfomodel.athleteType,
                  onChanged: (value) {
                    setState(() {
                      widget.userinfomodel.athleteType = value;
                    });
                  }),
            ],
          ),
        )
      ],
    );
  }

  void _showBirthdayPicker() async {
    Locale myLocale = Localizations.localeOf(context);
    var picker = await showDatePicker(
        context: context,
        initialDate: widget.userinfomodel.birthday,
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime(DateTime.now().year - 3));
    setState(() {
      if (picker != null) {
        print(picker);
        widget.userinfomodel.birthday = picker;
      }
    });
  }

  Widget birthdayAndClothesWeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TitleInput(
              text: 'clothesWeight',
              initValue: widget.userinfomodel.clothesWeight.toString(),
              textOnChange: (value) {
                if (value != null) {
                  setState(() {
                    widget.userinfomodel.clothesWeight = double.parse(value);
                  });
                }
              }),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(text: 'birthday'),
              RaisedButton(
                child: PaddingText(
                  text:
                      '${widget.userinfomodel.birthday.year}-${widget.userinfomodel.birthday.month}-${widget.userinfomodel.birthday.day}',
                  insets: EdgeInsets.zero,
                ),
                onPressed: _showBirthdayPicker,
              )
            ],
          ),
        )
      ],
    );
  }
}
