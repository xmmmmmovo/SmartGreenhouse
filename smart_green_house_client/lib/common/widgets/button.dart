import 'package:flutter/material.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';

/// 扁平圆角按钮
Widget btnFlatButtonWidget({
  @required VoidCallback onPressed,
  double width = 140,
  double height = 44,
  Color gbColor = AppColors.primaryElement,
  String title = "button",
  Color fontColor = AppColors.primaryElementText,
  double fontSize = 18,
  String fontName = "Montserrat",
  FontWeight fontWeight = FontWeight.w400,
}) {
  return Container(
    width: duSetWidth(width),
    height: duSetHeight(height),
    child: FlatButton(
      onPressed: onPressed,
      color: gbColor,
      shape: RoundedRectangleBorder(
        borderRadius: Radii.k6pxRadius,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: fontColor,
          fontFamily: fontName,
          fontWeight: fontWeight,
          fontSize: duSetFontSize(fontSize),
          height: 1,
        ),
      ),
    ),
  );
}

/// 第三方按钮
Widget btnFlatButtonBorderOnlyWidget({
  @required VoidCallback onPressed,
  double width = 88,
  double height = 44,
  String iconFileName,
}) {
  return Container(
    width: duSetWidth(width),
    height: duSetHeight(height),
    child: FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        side: Borders.primaryBorder,
        borderRadius: Radii.k6pxRadius,
      ),
      child: Image.asset(
        "assets/images/icons-$iconFileName.png",
      ),
    ),
  );
}

class CircleIconButton extends StatelessWidget {
  final double size;
  final Function onPressed;
  final IconData icon;

  CircleIconButton({this.size = 30.0, this.icon = Icons.clear, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment(0.0, 0.0), // all centered
          children: <Widget>[
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey[300]),
            ),
            Icon(
              icon,
              size: size * 0.6, // 60% width for icon
            )
          ],
        ),
      ),
    );
  }
}

class RecordButton extends StatefulWidget {
  RecordButton({
    this.leftWidget,
    this.rightWidget,
    this.onClick,
    @required this.isActive,
  });

  final bool isActive;
  final Widget leftWidget;
  final Widget rightWidget;
  final Function(bool) onClick;

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  Animation<double> _animation2;
  AnimationController _controller;
  AnimationController _controller2;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _controller2 =
            AnimationController(vsync: this, duration: Duration(seconds: 2))
              ..repeat();
        _animation2 =
            CurvedAnimation(parent: _controller2, curve: Curves.linear);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Widget _buttonWave(Animation<double> animation) {
    return Center(
      child: ScaleTransition(
        scale: animation,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Colors.red,
              style: BorderStyle.solid,
            ),
          ),
          height: 140,
          width: 140,
        ),
      ),
    );
  }

  Widget _displaysButtonWave2() {
    if (widget.isActive && _animation2 != null) {
      return _buttonWave(_animation2);
    } else {
      return Container(
        height: 140,
        width: 140,
      );
    }
  }

  Widget _displaysButtonWave1() {
    if (widget.isActive && _animation != null) {
      return _buttonWave(_animation);
    } else {
      return Container(
        height: 140,
        width: 140,
      );
    }
  }

  Widget _displaysRecordingButton() {
    return Container(
      margin: EdgeInsets.only(top: 35),
      child: ButtonTheme(
        minWidth: 70.0,
        height: 70.0,
        child: RaisedButton(
          onPressed: () {
            widget.onClick(widget.isActive);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          elevation: widget.isActive ? null : 0,
          color: widget.isActive ? Colors.red : Color(0xFFededed),
          child: Icon(
            Icons.mic,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _displaysButtonWave1(),
        _displaysButtonWave2(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.leftWidget != null
                ? widget.leftWidget
                : Expanded(
                    child: Container(),
                  ),
            _displaysRecordingButton(),
            widget.rightWidget != null
                ? widget.rightWidget
                : Expanded(
                    child: Container(),
                  ),
          ],
        ),
      ],
    );
  }
}
