import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/rendering.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

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
    bool isAvailable = await SignInWithApple.isAvailable();

    // iOS 13 이상일 경우
    if (isAvailable) {
      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: "needlecrew.amuz.com",
            redirectUri: Uri.parse(
                "https://noiseless-butter-sight.glitch.me/callbacks/sign_in_with_apple"),
          ),
        );

        final oauthCredential = firebase.OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );

        firebase.UserCredential userCredential = await firebase
            .FirebaseAuth.instance
            .signInWithCredential(oauthCredential);

        print("iOS 13 이상 this user info " + userCredential.user!.toString());
        print("this user email " + userCredential.user!.email.toString());


        final int index = userCredential.user!.email!.indexOf('@');
        String userName = userCredential.user!.email!.substring(0, index);


        joinUs(userName,
            '${userCredential.user!.email}', userName, 'apple');
        Login(userCredential.user!.email.toString(), userName);
      } catch (e) {
        print("appleLogin Error this " + e.toString());
      }
    } else { // iOS 13 미만일 경우
      final clientState = Uuid().v4();
      final url = Uri.https('appleid.apple.com', '/auth/authorize', {
        'response_type': 'code id_token',
        'client_id': "needlecrew.amuz.com",
        'response_mode': 'form_post',
        'redirect_uri':
            'https://noiseless-butter-sight.glitch.me/callbacks/apple/sign_in',
        'scope': 'email name',
        'state': clientState,
      });

      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: "applink");

      final body = Uri.parse(result).queryParameters;
      final oauthCredential = firebase.OAuthProvider("apple.com").credential(
        idToken: body['id_token'],
        accessToken: body['code'],
      );


      firebase.UserCredential userCredential = await firebase.FirebaseAuth.instance.signInWithCredential(oauthCredential);


      print("this user email " + userCredential.user!.email.toString());
      print("this user email " + userCredential.user!.email.toString());

      final int index = userCredential.user!.email!.indexOf('@');
      String userName = userCredential.user!.email!.substring(0, index);

      joinUs(userName,
          '${userCredential.user!.email}', userName, 'apple');
      Login(userCredential.user!.email.toString(), userName);
    }
  }

  // naver 로그인
  void naverLogin() async {
    try {
      NaverLoginResult res = await FlutterNaverLogin.logIn();

      NaverAccountResult accountResult =
          await FlutterNaverLogin.currentAccount();

      joinUs(res.account.name, res.account.email, res.account.id, 'naver');
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

        joinUs('${user.kakaoAccount?.profile?.nickname}',
            '${user.kakaoAccount?.email}', '${user.id}', 'kakao');

        Login('${user.kakaoAccount?.email}', '${user.id}');
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
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          User user = await UserApi.instance.me();
          print("kakaoUser this     " + user.toString());

          joinUs('${user.kakaoAccount?.profile?.nickname}',
              '${user.kakaoAccount?.email}', '${user.id}', 'kakao');

          Login('${user.kakaoAccount?.email}', '${user.id}');

          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();

        User user = await UserApi.instance.me();
        // print("kakaoUser this     " + user.kakaoAccount!.email.toString());

        joinUs('${user.kakaoAccount?.profile?.nickname}',
            '${user.kakaoAccount?.email}', '${user.id}', 'kakao');

        Login('${user.kakaoAccount?.email}', '${user.id}');

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
              appleLogin();
            } else if (widget.loginwith == "google") {
              googleLogin();
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
