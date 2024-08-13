import 'package:flutter/material.dart';

///间距
SizedBox hiSpace({double height = 1, double width = 1}) {
  return SizedBox(height: height, width: width);
}

///添加阴影 todo 这是给添加进来的组件包裹一层阴影,只有再组件有透明度的时候才能有效果(即opacity<1)
/// todo padding 其实说白了是对包裹进来的child的一个偏移,为了更好的凸显一点阴影效果,感觉作用不大
Widget shadowWarp(
    {required Widget child,
    EdgeInsetsGeometry? padding,
    Color startColor = const Color(0x66000000)}) {
  return Container(
    padding: padding,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            //AppBar渐变遮罩背景
            colors: [startColor, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter)),
    child: child,
  );
}
