import 'package:flutter/material.dart';
import 'auth.dart';
import 'login_page.dart';
import 'category_route.dart';


class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        result = LoginPage(
          title: 'Login Page',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
        break;
      case AuthStatus.signedIn:
        result =  new CategoryRoute(
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
        );
        break;
    }
    return result;
  }


}