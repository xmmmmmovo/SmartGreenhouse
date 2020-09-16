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
  bool _isShow = false;
  AppState appState;
  List<WordData> data = [];
  int index = 0;
  String headmsg = "请稍等";
  String waitmsg = "点击此处查看释义";
  final _random = Random();
  AudioPlayer audio = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  int next(int min, int max) => min + _random.nextInt(max - min);

  void fetchData() async {
    var tmp = await getWordData(context: context);
    setState(() {
      data.addAll(tmp.data);
      index = next(0, data.length);
      headmsg = data[index].word;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  _buildHead() {
    return Center(
      child: Container(
        height: duSetHeight(120),
        alignment: Alignment.center,
        color: AppColors.primaryBackground,
        child: Card(
          margin: const EdgeInsets.all(10.0),
          color: AppColors.primaryElement,
          elevation: 10,
          // 阴影
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
//              side: BorderSide(color: Colors.green,width: 25),
          ),
//            borderOnForeground: false,
          child: ListTile(
            title: Text(headmsg,
                style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryElementText,
                    fontWeight: FontWeight.w500)),
            subtitle: Row(
              children: <Widget>[
                Text("点击听读音:",
                    style: TextStyle(
                        color: AppColors.primaryElementText,
                        fontWeight: FontWeight.w500)),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  color: Colors.white,
                  onPressed: () async {
                    int res = await audio.play(
                        Uri.encodeFull(YOUDAO_PRONUNCIATION_BASEURL + headmsg));
                    if (res == 1) {
                      toastInfo(msg: "成功播放");
                    } else {
                      toastInfo(msg: "播放失败");
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCard(String title, String subtitle) {
    return Card(
        child: ListTile(
      title: Text(
        title,
        style: TextStyle(fontFamily: "gengsha"),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontFamily: "gengsha"),
      ),
    ));
  }

  _build_show() {
    return Expanded(
      child: Column(
        children: <Widget>[
          divider10Px(),
//          _buildCard("音标", "eɪ"),
          _buildCard(
              "翻译",
              data[index].translation != null
                  ? data[index].translation
                  : "暂无数据"),
          _buildCard(
              "当前/总计", "${appState.remainWords}/${Global.profile.todayWords}"),
          Container(
              height: duSetHeight(44),
              margin: EdgeInsets.only(top: duSetHeight(15)),
              child: Row(
                children: <Widget>[
                  btnFlatButtonWidget(
                      title: "知道",
                      onPressed: () async {
                        await uploadRemeberedWord(
                            context: context,
                            params: RemeberedWordRequest(
                                userName: Global.profile.displayName,
                                wordId: data[index].id));
                        appState.wordPlusOne();
                        data.removeAt(index);
                        index = next(0, data.length);
                        headmsg = data[index].word;
                        _isShow = false;
                        if (data.length <= 1) {
                          fetchData();
                        }
                      },
                      fontName: "gengsha",
                      gbColor: AppColors.primaryBackground,
                      fontColor: AppColors.primaryText,
                      width: duSetWidth(150)),
                  Spacer(),
                  btnFlatButtonWidget(
                      title: "不知道",
                      onPressed: () {
                        setState(() {
                          index = next(0, data.length);
                          headmsg = data[index].word;
                          _isShow = false;
                        });
                      },
                      fontName: "gengsha",
                      width: duSetWidth(150)),
                ],
              )),
        ],
      ),
    );
  }

  _build_hide() {
    return Expanded(
      child: Center(
          child: GestureDetector(
        child: Text(
          appState.remainWords > Global.profile.todayWords
              ? "今日的学习目标已达成"
              : waitmsg,
          style: TextStyle(fontSize: 36, fontFamily: "gengsha"),
        ),
        onTap: () {
          if (data.length == null) {
            toastInfo(msg: "请稍等");
            return;
          }
          setState(() {
            _isShow = true;
          });
        },
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHead(),
          _isShow ? _build_show() : _build_hide(),
        ],
      ),
    );
  }
}
