// import 'package:firebase_auth/firebase_auth.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class CircleIconBtn extends StatefulWidget {
  final String icon;
  final String loginwith;

  const CircleIconBtn({Key? key, required this.icon, required this.loginwith})
      : super(key: key);

  @override
  State<CircleIconBtn> createState() => _CircleIconBtnState();
}

class _CircleIconBtnState extends State<CircleIconBtn> {
  late ValueSetter<AuthorizationCredentialAppleID> onSignIn;

  @override
  void initState() {
    super.initState();
  }

  // google 로그인
  void googleLogin() async {

    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        // scopes: ['displayName', 'email', 'id'],
      );

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;


      await _googleSignIn;

      joinUs('${googleUser.displayName}', '${googleUser.email}',
          '${googleUser.id}', '');
      Login(googleUser.email, googleUser.id);



    } catch (error) {
      print("isError $error");
    }
  }

  // apple 로그인
  void appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'needlecrew',
        redirectUri: Uri.parse('https://needlecrew.com'),
      ),
    );


    onSignIn(credential);
    joinUs('${credential.familyName}' + '${credential.givenName}',
        '${credential.email}', '${credential.identityToken}', '');
    Login('${credential.email}', '${credential.identityToken}');

  }

  // naver 로그인
  void naverLogin() async {
    try {
      NaverLoginResult res = await FlutterNaverLogin.logIn();

      NaverAccountResult accountResult = await FlutterNaverLogin.currentAccount();

      joinUs(res.account.name, res.account.email, res.account.id, accountResult.mobile);
      Login(res.account.email, res.account.id);

      print(res.account.name + '네이버 로그인 성공');
    } catch (error) {
      print("네이버 로그인 실패 isError $error");
    }
  }



  // 카카오 로그인
  Future<void> kakaoLogin() async {
    // 카카오톡이 설치되어 있을 경우 (카카오톡 로그인)
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        User user = await UserApi.instance.me();

        joinUs('${user.kakaoAccount?.name}', '${user.kakaoAccount?.email}',
            '${user.id}', '${user.kakaoAccount?.phoneNumber}');

        Login('${user.kakaoAccount?.email}',
            '${user.id}');
        print('카카오톡 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오톡 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        // 카카오톡에 연결된 카카오계정이 없는 경우 (카카오계정으로 로그인)
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      child: GestureDetector(
        onTap: () {
          try {
            if (widget.loginwith == "kakao") {
              kakaoLogin();
            } else if (widget.loginwith == "naver") {
              naverLogin();
            } else if (widget.loginwith == "apple") {
              // appleLogin();
            } else if (widget.loginwith == "google") {
              // googleLogin();
            }
          } catch (error) {
            print("isError $error");
            return;
          }
        },
        child: Image.asset(
          "assets/icons/" + widget.icon,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
