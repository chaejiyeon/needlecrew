import  'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Channeltalk extends StatefulWidget {
  const Channeltalk({Key? key}) : super(key: key);

  @override
  State<Channeltalk> createState() => _ChanneltalkState();
}

class _ChanneltalkState extends State<Channeltalk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://needlecrew.channel.io',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

