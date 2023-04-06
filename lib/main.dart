import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/controller/widget_controller/initial_bindings.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/getxServices/home_init_service.dart';
import 'package:needlecrew/screens/login/loading_page.dart';
import 'package:needlecrew/screens/login/login_page.dart';
import 'package:needlecrew/screens/main/fix_clothes.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_register_info.dart';
import 'package:needlecrew/screens/main/myPage/pay_type_add.dart';
import 'package:needlecrew/screens/main/myPage/pay_type_add_confirm.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';

import 'screens/join/agree_terms.dart';
import 'screens/main/myPage/pay_type.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
  KakaoSdk.init(
      nativeAppKey: 'e30822d334ce26f168c65295d55a25b0', loggingEnabled: true);

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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Needlecrew',
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBindings(),
          theme: ThemeData(
            fontFamily: 'NotoSansCJKkrRegular',
            primaryColor: Colors.white,
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
            ),
          ),
          home: Obx(() => homeInitService.mainHome.value.value ?? Container()),
          getPages: [
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(name: '/join', page: () => AgreeTerms()),
            GetPage(name: '/startPage', page: () => LoadingPage()),
            GetPage(name: '/mainHome', page: () => MainPage(pageNum: 0)),
            GetPage(
                name: '/useInfoReady',
                page: () => MainPage(pageNum: 1, selectTab: 0)),
            GetPage(
                name: '/useInfoProgress',
                page: () => MainPage(pageNum: 1, selectTab: 1)),
            GetPage(
                name: '/useInfoComplete',
                page: () => MainPage(pageNum: 1, selectTab: 2)),
            GetPage(name: '/myPage', page: () => MainPage(pageNum: 2)),
            GetPage(name: '/fixClothes', page: () => FixClothes()),
            GetPage(name: '/fixRegisterInfo', page: () => FixRegisterInfo()),
            GetPage(
                name: '/payTypeAddConfirmFirst',
                page: () => PayTypeAddConfirm(
                      isFirst: true,
                    )),
            GetPage(
                name: '/payTypeAddConfirm',
                page: () => PayTypeAddConfirm(
                      isFirst: false,
                    )),
            GetPage(name: '/payType', page: () => PayType()),
            GetPage(name: '/payTypeAdd', page: () => PayTypeAdd(isFirst: true)),
          ],
        );
      },
    );
  }
}

class MyHomePage extends GetView<HomeInitService> {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeInitService.mainHome.value.value ?? Container());
  }
}
