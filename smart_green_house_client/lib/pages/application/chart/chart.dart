import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_green_house_client/common/provider/provider.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  AppState _appState;
  Timer _timer;

  _startTimmer() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      setState(() {
        _appState.fetchSensorData();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimmer();
  }

  @override
  void dispose() {
    if (_timer != null) {
      // 页面销毁时触发定时器销毁
      if (_timer.isActive) {
        // 判断定时器是否是激活状态
        _timer.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);

    return Container(
      child: Echarts(
        option: '''
        {
        xAxis: {
          data: ${_appState.sensorData.map((e) => '\'${DateFormat("yyyy-MM-dd hh:mm:ss").format(HttpDate.parse(e.recordTime))}\'').toList().toString()},
          boundaryGap: false,
          axisTick: {
            show: false
          }
        },
        grid: {
          left: 10,
          right: 10,
          bottom: 20,
          top: 30,
          containLabel: true
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross'
          },
          padding: 8
        },
        yAxis: {
          axisTick: {
            show: false
          }
        },
        legend: {
          data: ['温度', '湿度']
        },
        series: [{
          name: '温度',
          itemStyle: {
            color: '#FF005A',
            lineStyle: {
              color: '#FF005A',
              width: 2
            }
          },
          smooth: true,
          type: 'line',
          data: ${_appState.sensorData.map((e) => e.temperature).toList().toString()},
          animationDuration: 2800,
          animationEasing: 'cubicInOut'
        },
        {
          name: '湿度',
          smooth: true,
          type: 'line',
          itemStyle: {
            color: '#3888fa',
            lineStyle: {
              color: '#3888fa',
              width: 2
            },
            areaStyle: {
              color: '#f3f8ff'
            }
          },
          data: ${_appState.sensorData.map((e) => e.humidity.toString()).toList().toString()},
          animationDuration: 2800,
          animationEasing: 'quadraticOut'
        }]
      } 
        ''',
      ),
    );
  }
}
