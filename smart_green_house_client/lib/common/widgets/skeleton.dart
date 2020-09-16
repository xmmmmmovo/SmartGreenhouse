import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

/// 骨架屏-卡片
Widget cardListSkeleton() {
  return PKCardListSkeleton(
    isCircularImage: true,
    isBottomLinesActive: false,
    length: 10,
  );
}

/// 页面骨架屏
Widget pageSkeleton() {
  return PKCardPageSkeleton(
    totalLines: 5,
  );
}
