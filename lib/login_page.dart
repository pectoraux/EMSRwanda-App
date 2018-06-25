import 'package:flutter/material.dart';
import 'primary_button.dart';
import 'auth.dart';
import 'color_override.dart';
import 'constants.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();
  var _login = GlobalKey(debugLabel: 'Login');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool active = true;
  String _authHint = 'Type in your details and press the Login button';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = await widget.auth.signIn(_usernameController.text, _passwordController.text);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();

      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16.0),
                Text(
                  'LATERITE',
                  style: TodoColors.textStyle6.apply(color: TodoColors.baseColors[0]),
                ),
              ],
            ),
            Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:<Widget>[
            SizedBox(height: 120.0),
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextFormField(
                key: new Key('Username'),
                autocorrect: false,
                controller: _usernameController,
                validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
                onSaved: (val) => _usernameController.text = val,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: TodoColors.baseColors[0]),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            new PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextFormField(
                key: new Key('password'),
                obscureText: true,
                autocorrect: false,
                controller: _passwordController,
                validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
                onSaved: (val) => _passwordController.text = val,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: TodoColors.baseColors[0]),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL', style: TextStyle(color: TodoColors.baseColors[0]),),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                active? RaisedButton(
                    child: Text('LOG IN', style: TextStyle(color: TodoColors.baseColors[0]),),
                    elevation: 8.0,
                    key: _login,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: (){
                      validateAndSubmit();
                    }
                ):Container(),
              ],
            ),],),
      ),
            hintText()

          ],
        ),
      ),
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}