import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:futsal_unique/common_widgets/OutlinedButtonWidget.dart';
import 'package:futsal_unique/common_widgets/instaDart_richText.dart';
import 'package:futsal_unique/screens/accueil/accuiel.dart';
import 'package:futsal_unique/screens/login/login_middle_page.dart';
import 'package:futsal_unique/screens/login/signup_screen.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isHiddenPassword = true;
  bool _isLogin = true;
  bool isLoading = false;
  String? email, password;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  _trySubmit() async {
    UserCredential authResult;
    final isValidate = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValidate) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        if (_isLogin) {
          print("im here");
          authResult = await _auth.signInWithEmailAndPassword(
              email: email!, password: password!);
          print("logged in successfully");
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email!, password: password!);
          print("user created successfully");
        }
      } on FirebaseAuthException catch (err) {
        setState(() {
          isLoading = false;
        });
        var message =
            "Une erreur s'est produite, veuillez vérifier les informations saisies";
        if (err.message != null) {
          print("le code d'erreur:" + err.code);
          switch (err.code) {
            case "invalid-email":
              // message = "Your email address appears to be malformed.";
              message = "L'email est mal formée.";
              break;
            case "wrong-password":
              // message = "Your password is wrong.";
              message = "Votre mot de passe est incorrect.";
              break;
            case "user-disabled":
              // message = "User with this email has been disabled.";
              message = "Le compte associé à cet email est désactivé.";
              break;
            case "user-not-found":
              // message = "No user found for that email.";
              message = "Cet email n'est associé à aucun compte.";
              break;
            case "network-request-failed":
              message =
                  "Connexion interrompue. Vérifiez si vous êtes connecté à internet.";
              break;
            default:
              message =
                  "Une erreur s'est produite, veuillez vérifier les informations saisies.";
          }
        }
        Get.snackbar('Problème survenu', message,
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        print("lerreur est" + err.toString());
        var message =
            "Une erreur s'est produite, veuillez vérifier les informations saisies";
        Get.snackbar('Problème survenu', message,
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  _pushAndRemoveUntil(Widget screen){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => screen), (Route<dynamic> route) => false);
  }

  _togglePassword() {
    print('tapped before to show $isHiddenPassword');

    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
    print('tapped after to show $isHiddenPassword');
  }

  Widget build(BuildContext context) {
    print("is loading is : " + isLoading.toString());
    return Scaffold(body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: colorButton,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(70),
                  bottomRight: const Radius.circular(70),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLogo(),
                _buildContainer(),
                _buildSignUpBtn(),
              ],
            ),
          )
        ],
      ),);
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: InstaDartRichText(
              kBillabongFamilyTextStyle.copyWith(fontSize: 50.0)),
          /*Text(
              'FUTSAL',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),*/
        )
      ],
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        key: ValueKey('email'),
        keyboardType: TextInputType.emailAddress,
        // onChanged: (value) {
        //   setState(() {
        //     email = value;
        //   });
        // },
        validator: (value) {
          if (value == null || value.isEmpty || !value.contains('@')) {
            return 'Veuillez saisir une adresse email valide';
          }
          return null;
        },
        onSaved: (value) {
          email = value!.trim();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: colorButton,
          ),
          labelText: 'E-mail',
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        key: ValueKey('password'),
        keyboardType: TextInputType.text,
        obscureText: isHiddenPassword,
        validator: (value) {
          if (value == null || value.isEmpty || value.length < 6) {
            return 'Le mot de passe doit inclure au moins 6 caractères';
          }
        },
        onSaved: (value) {
          password = value!.trim();
        },
        // onChanged: (value) {
        //   setState(() {
        //     password = value;
        //   });
        // },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: colorButton,
          ),
          suffixIcon: InkWell(
            onTap: _togglePassword,
            child: (!isHiddenPassword)
                ? Icon(
              LineIcons.eye,
              color: Colors.grey,
            )
                : Icon(
              LineIcons.eyeSlash,
              color: Colors.grey,
            ),
          ),
          labelText: 'Mot de passe',
        ),
      ),
    );
  }

  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text("Mot De Passe Oublié ?"),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return isLoading
        ? Container(
        height: 40,
        width: 40,
        child: FittedBox(child: CircularProgressIndicator()))
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: colorButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: _trySubmit,
            child: Text(
              _isLogin ? "Se Connecter" : "S'inscrire",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildOrRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            '- OU -',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff2470c7),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0)
              ],
            ),
            child: Icon(
              LineIcons.googlePlusG,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff2470c7),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0)
              ],
            ),
            child: Icon(
              LineIcons.facebook,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*Center(
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                        ),
                      ),
                    ),*/
                  Expanded(
                      child: SizedBox(
                        height: 5,
                      )),
                  Expanded(child: _buildEmailRow()),
                  Expanded(child: _buildPasswordRow()),
                  Expanded(child: _buildForgetPasswordButton()),
                  Expanded(child: _buildLoginButton()),
                  Expanded(child: _buildOrRow()),
                  Expanded(child: _buildSocialBtnRow()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: FlatButton(
            onPressed: () {},
            child:
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _isLogin
                          ? 'Vous n\'avez pas compte? '
                          : 'Vous êtes déja inscrit?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: _isLogin ? 'S\'inscrire' : 'Se connecter',
                      style: TextStyle(
                        color: colorButton,
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        print('bool vaiable is :  $_isLogin"');
                        if(_isLogin){
                          _pushAndRemoveUntil(LoginMiddlePage());
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
        ),
      ],
    );
  }
}
