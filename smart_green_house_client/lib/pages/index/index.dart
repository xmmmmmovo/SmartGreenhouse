import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/global.dart';
import 'package:smart_green_house_client/pages/application/application.dart';
import 'package:smart_green_house_client/pages/sign_in/sign_in.dart';
import 'package:smart_green_house_client/pages/welcome/welcome.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: 375,
      height: 812 - 44 - 34,
      allowFontScaling: true,
    );

    return Scaffold(
      body: Global.isFirstOpen == true
          ? WelcomePage()
          : Global.isOfflineLogin == true ? ApplicationPage() : SignInPage(),
    );
  }
}
