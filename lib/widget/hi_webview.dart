import 'package:flutter/material.dart';
import 'package:trip_flutter/util/navigator_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

///H5容器
class HiWebView extends StatefulWidget {
  final String? url;
  final String? statusBarColor;
  final String? title;
  final bool? hideAppBar;

  ///禁止我的页面返回按钮
  final bool? backForbid;

  const HiWebView(
      {super.key,
      this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid});

  @override
  State<HiWebView> createState() => _HiWebViewState();
}

class _HiWebViewState extends State<HiWebView> {
  ///主页代表的url
  final _catchUrls = [
    'm.ctrip.com/',
    'm.ctrip.com/html5/',
    'm.ctrip.com/html5'
  ];
  String? url;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    if (url != null && url!.contains('ctrip.com')) {
      //fix 携程H5 http://无法打开问题
      url = url!.replaceAll("http://", "https://");
    }
    _initWebViewController();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    //处理Android物理返回键，返回H5的上一页 https://docs.flutter.dev/release/breaking-changes/android-predictive-back
    return PopScope(
        canPop: false, //禁用默认的返回键逻辑,H5页我自己来处理逻辑
        onPopInvoked: (bool didPop) async {
          if (await controller.canGoBack()) {
            //返回H5的上一页
            controller.goBack();
          } else {
            if (context.mounted) NavigatorUtil.pop(context);
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              _appBar(
                  Color(int.parse('0xff$statusBarColorStr')), backButtonColor),
              Expanded(
                  child: WebViewWidget(
                controller: controller,
              ))
            ],
          ),
        ));
  }

  void _initWebViewController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('progress:$progress');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            //页面加载完成之后才能执行JS
            _handleBackForbid();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            ///当内部要跳转时,进行一层拦截逻辑处理
            if (_isToMain(request.url)) {
              debugPrint('阻止跳转到 $request}');
              //返回到flutter页面
              NavigatorUtil.pop(context);
              return NavigationDecision.prevent;
            }
            debugPrint('允许跳转到 $request}');
            return NavigationDecision.navigate;
          }))
      ..loadRequest(Uri.parse(url!));
  }

  ///隐藏H5登录页的返回键
  void _handleBackForbid() {
    ///todo 1、display:none 元素不再占用空间。 2、visibility: hidden 使元素在网页上不可见，但仍占用空间。

    // const jsStr =
    //     "var element = document.querySelector('.animationComponent.rn-view'); if(element!=null)element.style.display = 'none';";

    const jsStr =
        "var element = document.querySelector('.animationComponent.rn-view'); if(element!=null)element.style.visibility = 'hidden';";

    if (widget.backForbid ?? false) {
      controller.runJavaScript(jsStr);
    }
  }

  ///判断H5是否返回主页
  bool _isToMain(String? url) {
    print('_isToMain url:$url');
    bool contain = false;
    for (final value in _catchUrls) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  ///纯手动处理statusBar的颜色,因为根据安全距离可以直到statusBar的大小,并且默认是"内嵌"上去的
  ///只要设置"内嵌"上去的这个区域的颜色就能间接的设置statusBar的颜色
  _appBar(Color backgroundColor, Color backButtonColor) {
    //获取刘海屏Top安全边距
    double top = MediaQuery.of(context).padding.top;
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: top,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, top, 0, 0),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [_backButton(backButtonColor), _title(backButtonColor)],
          ),
        ),
      ),
    );
  }

  _backButton(Color backButtonColor) {
    return GestureDetector(
      onTap: () {
        //这里的返回按钮×,直接返回到Flutter页面(不做H5记录中的逐级返回了)
        NavigatorUtil.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Icon(
          Icons.close,
          color: backButtonColor,
          size: 26,
        ),
      ),
    );
  }

  _title(Color backButtonColor) {
    ///采用Container可以更加灵活,让其child根据内容去撑开,想要有padding效果的话,外层在嵌套一层就ok
    return Container(
      alignment: Alignment.center,
      child: Text(
        widget.title ?? "未知",
        style: TextStyle(color: backButtonColor, fontSize: 16),
      ),
    );
  }
}
