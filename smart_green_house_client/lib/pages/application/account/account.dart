import 'package:auto_route/auto_route.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/apis/apis.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/provider/provider.dart';
import 'package:smart_green_house_client/common/router/router.gr.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';
import 'package:smart_green_house_client/common/widgets/widgets.dart';
import 'package:smart_green_house_client/global.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController _todayWordsController = TextEditingController();

  // 个人页面 头部
  Widget _buildUserHeader() {
    return Container(
      height: duSetWidth(268),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: duSetWidth(333),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: duSetWidth(2),
                    decoration: BoxDecoration(
                      color: AppColors.tabCellSeparator,
                    ),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            right: 20,
            bottom: 21,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 头像
                Container(
                  height: duSetWidth(198),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 9),
                        child: Text(
                          Global.profile.username,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Text(
                        "权限: " + Global.profile.roles[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 列表项
  Widget _buildCell({
    String title,
    String subTitle,
    int number,
    bool hasArrow = false,
    VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: duSetWidth(60),
        color: Colors.white,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // 背景
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: duSetWidth(60),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: duSetWidth(1),
                      decoration: BoxDecoration(
                        color: AppColors.tabCellSeparator,
                      ),
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            // 右侧
            Positioned(
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 数字
                  number == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(right: 11),
                          child: Text(
                            number.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.w400,
                              fontSize: duSetFontSize(18),
                            ),
                          ),
                        ),
                  // 箭头
                  hasArrow == false
                      ? Container()
                      : Container(
                          width: duSetWidth(24),
                          height: duSetWidth(24),
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primaryText,
                          ),
                        ),
                ],
              ),
            ),

            // 标题
            title == null
                ? Container()
                : Positioned(
                    left: 20,
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "gengsha",
                        fontWeight: FontWeight.w400,
                        fontSize: duSetFontSize(18),
                      ),
                    ),
                  ),

            // 子标题
            subTitle == null
                ? Container()
                : Positioned(
                    right: 20,
                    child: Text(
                      subTitle,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "gengsha",
                        fontWeight: FontWeight.w400,
                        fontSize: duSetFontSize(18),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Text returnStyledText(String s) {
    return Text(s,
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: "gengsha",
          fontWeight: FontWeight.w400,
          fontSize: duSetFontSize(18),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildUserHeader(),
          divider10Px(),
          _buildCell(
            title: "管理设备数",
            number: appState.hardwareData.length,
            hasArrow: true,
          ),
          divider10Px(),
          _buildCell(
            title: "墨水屏模式",
            hasArrow: true,
            onTap: () => appState.switchGrayFilter(),
          ),
          _buildCell(
            title: "登出",
            hasArrow: true,
            onTap: () => goLoginPage(context),
          ),
          divider10Px(),
        ],
      ),
    );
  }
}
