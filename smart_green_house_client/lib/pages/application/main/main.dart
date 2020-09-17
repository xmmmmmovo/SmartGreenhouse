import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:smart_green_house_client/common/apis/apis.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/provider/app.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';
import 'package:smart_green_house_client/common/widgets/widgets.dart';
import 'package:smart_green_house_client/global.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AppState appState;

  void fetchData() async {}

  @override
  void initState() {
    super.initState();
  }

  _buildCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: AppColors.primaryElement,
      elevation: 10,
      // 阴影
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey, width: 1),
      ),
//            borderOnForeground: false,
      child: ListTile(
        title: Text(title,
            style: TextStyle(
                fontSize: 20,
                color: AppColors.primaryElementText,
                fontWeight: FontWeight.w500)),
        subtitle: Row(
          children: <Widget>[
            Text(value,
                style: TextStyle(
                    fontSize: 40,
                    color: AppColors.primaryElementText,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  _buildContainer() {
    return Center(
        child: Container(
            alignment: Alignment.center,
            color: AppColors.primaryBackground,
            child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //横轴三个子widget
                    childAspectRatio: 1.0 //宽高比为1时，子widget
                    ),
                children: <Widget>[
                  _buildCard('温度', '暂无'),
                  _buildCard('湿度', '暂无'),
                  _buildCard('火灾风险', '暂无'),
                  _buildCard('失水风险', '暂无'),
                  _buildCard('光照不足风险', '暂无')
                ])));
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    return _buildContainer();
  }
}
