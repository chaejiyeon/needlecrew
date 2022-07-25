import 'dart:async';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/login/startPage.dart';
import 'package:needlecrew/screens/login/login.dart';
import 'package:needlecrew/screens/main/fixClothes.dart';
import 'package:needlecrew/screens/main/fixClothes/chooseClothes.dart';
import 'package:needlecrew/screens/main/fixClothes/fixRegisterInfo.dart';
import 'package:needlecrew/screens/main/myPage.dart';
import 'package:needlecrew/screens/main/myPage/payTypeAdd.dart';
import 'package:needlecrew/screens/main/myPage/payTypeAddConfirm.dart';
import 'package:needlecrew/screens/mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';

import 'screens/join/agreeTerms.dart';
import 'screens/main/myPage/payType.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
  KakaoSdk.init(nativeAppKey: 'e30822d334ce26f168c65295d55a25b0', loggingEnabled: true);

  wp_api.wooCommerceApi = FlutterWooCommerceApi(
    baseUrl: 'https://needlecrew.com',
    consumerKey: 'ck_75c6d6983771d3923a5dc58c1151039ab96167c1',
    consumerSecret: 'cs_36e34b80b2ccc76c587069cb7b121f6df6758deb',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
    ));

    return GetMaterialApp(
      title: 'Nidlecrew',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansCJKkrRegular',
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
        ),
      ),
      home: const MyHomePage(),
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/join', page: () => AgreeTerms()),
        GetPage(name: '/startPage', page: () => loadingPage()),
        GetPage(name: '/mainHome', page: () => MainPage(pageNum: 0)),
        GetPage(name: '/useInfoReady', page: () => MainPage(pageNum: 1, selectTab: 0)),
        GetPage(name: '/useInfoProgress', page: () => MainPage(pageNum: 1, selectTab: 1)),
        GetPage(name: '/useInfoComplete', page: () => MainPage(pageNum: 1, selectTab: 2)),
        GetPage(name: '/myPage', page: () => MainPage(pageNum: 2)),
        GetPage(name: '/fixClothes', page: () => FixClothes()),
        GetPage(name: '/fixRegisterInfo', page: () => FixRegisterInfo()),
        GetPage(name: '/payTypeAddConfirmFirst', page: () => PayTypeAddConfirm(isFirst: true,)),
        GetPage(name: '/payTypeAddConfirm', page: () => PayTypeAddConfirm(isFirst: false,)),
        GetPage(name: '/payType', page: () => PayType()),
        GetPage(name: '/payTypeAdd', page: () => PayTypeAdd(isFirst: true)),
      ],

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}




class _MyHomePageState extends State<MyHomePage> {
  late bool check = false;

  @override
  void initState() {
    super.initState();
    isLogged().then((value) {
      setState((){
        check = value;
      });
    });

    print("ischeck" + check.toString());

    Timer(Duration(milliseconds: 2000), () {
      if(check == false) {
        Get.to(loadingPage());
      }else{
        Get.toNamed('/mainHome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: HexColor("#fd9a03"),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 338,
                ),
                Container(
                  width: 170,
                  child: Image.asset("assets/icons/logoIcon.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

