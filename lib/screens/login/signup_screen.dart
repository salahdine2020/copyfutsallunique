import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futsal_unique/screens/login/login.dart';
import 'package:futsal_unique/services/services.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:futsal_unique/common_widgets/instaDart_richText.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password, _name;
  bool _isLoading = false;

  _submit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      //Signup user with Firebase
      try {
        await AuthService.signUpUser(context, _name!.trim(), _email!.trim(), _password!.trim());
      } on PlatformException catch (err) {
        _showErrorDialog(err!.message!);
        setState(() {
          _isLoading = false;
        });
        throw (err);
      }
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  _pushAndRemoveUntil(Widget screen){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => screen), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InstaDartRichText(
                    kBillabongFamilyTextStyle.copyWith(fontSize: 50.0)),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Please enter a valid name'
                              : null,
                          onSaved: (input) => _name = input,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (input) => !input!.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (input) => input!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                          onSaved: (input) => _password = input,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      if (_isLoading) CircularProgressIndicator(),
                      if (!_isLoading)
                        Container(
                          width: 250.0,
                          child: FlatButton(
                            onPressed: _submit,
                            color: Colors.blue,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Signup',
                              style: kFontColorWhiteSize18TextStyle,
                            ),
                          ),
                        ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: FlatButton(
                          onPressed: () {},
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _isLoading
                                      ? 'Vous n\'avez pas compte? '
                                      : 'Vous êtes déja inscrit?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.height / 40,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: _isLoading ? 'S\'inscrire' : 'Se connecter',
                                  style: TextStyle(
                                    color: colorButton,
                                    fontSize: MediaQuery.of(context).size.height / 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    print('bool vaiable is :  $_isLoading"');
                                    if(_isLoading){
                                      _pushAndRemoveUntil(SignupScreen());
                                    }else{
                                      _pushAndRemoveUntil(Login());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // if (!_isLoading)
                      //   Container(
                      //     width: 250.0,
                      //     child: FlatButton(
                      //       onPressed: () => Navigator.pop(context),
                      //       color: Colors.blue,
                      //       padding: const EdgeInsets.all(10.0),
                      //       child: Text(
                      //         'Back to Login',
                      //         style: kFontColorWhiteSize18TextStyle,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
