import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:webview_windows/webview_windows.dart';

class WebViewPage extends StatefulWidget{
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  final _controller = WebviewController();

  @override
  void initState(){
    super.initState();
    _initWebView();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Webview(_controller),
    );
  }

  Future<void> _initWebView() async{
    await _controller.initialize();

    await Future.wait([
      _controller.setBackgroundColor(Colors.white),
      _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny),
    ]);

    await _controller.loadUrl("https://www.google.com");

    if(context.mounted){
      setState((){});
    }
  }
}
