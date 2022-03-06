import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:futsal_unique/common_widgets/NavigationBar.dart';
import 'package:futsal_unique/common_widgets/OutlinedButtonWidget.dart';
import 'package:futsal_unique/common_widgets/instaDart_richText.dart';
import 'package:futsal_unique/screens/accueil/accuiel.dart';
import 'package:futsal_unique/screens/profile_screen/profile_screen.dart';
import 'package:futsal_unique/services/services.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginMiddlePage extends StatefulWidget {
  const LoginMiddlePage({Key? key}) : super(key: key);

  @override
  _LoginMiddlePageState createState() => _LoginMiddlePageState();
}

class _LoginMiddlePageState extends State<LoginMiddlePage> {
  bool isHiddenPassword = true;
  bool _isLogin = true;
  bool isLoading = false;
  bool _isLoading = false;
  String? name, email, password;
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          Navigator.of(context).pop("connected");
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email!, password: password!);
          await _firestore.collection("users").doc(_auth.currentUser!.uid.toString()).set({'email': email, 'uid': _auth.currentUser!.uid}).catchError((e) {
            print(e);
          });
          print("user created successfully");
          Navigator.of(context).pop("connected");
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
              message = "L'email est mal formé.";
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
            case "auth/email-already-exists":
              message =
                  "L'email fourni est déjà utilisé par un autre utilisateur.";
              break;
            default:
              message =
                  "Une erreur s'est produite, veuillez vérifier les informations saisies.";
          }
        }
        Get.snackbar('Problème survenu', message,
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        // Navigator.of(context).pop("not connected");
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

  _submit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      //Signup user with Firebase
      try {
        String userIDfromSignUp = await AuthService.signUpUser(
            context, name!.trim(), email!.trim(), password!.trim(),
        );
        _goToProfile(
          userID: userIDfromSignUp,
        );
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

  _goToProfile({userID}) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyBottomNavigatioBar(
        currentUserId: userID,
        userId: userID,
        index: 4,
      ),
    );
    return MaterialPageRoute(
      builder: (context) => MyBottomNavigatioBar(
        currentUserId: userID,
        userId: userID,
        index: 4,
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    print(">>>> after signIn method");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    print(">>>> after getting authentication");
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print(">>>> after GoogleAuthProvider.credential");

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Widget build(BuildContext context) {
    print("is loading is : " + isLoading.toString());
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

    Widget _buildNameRow() {
      return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          key: ValueKey('name'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          // onChanged: (value) {
          //   setState(() {
          //     email = value;
          //   });
          // },
          validator: (value) {},
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          onSaved: (value) {
            name = value!.trim();
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.perm_identity,
              color: colorButton,
            ),
            labelText: 'Nom',
          ),
        ),
      );
    }

    Widget _buildEmailRow() {
      return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          key: ValueKey('email'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,

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
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          onSaved: (value) {
            email = value!.trim();
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: colorButton,
              ),
              labelText: 'E-mail'),
        ),
      );
    }

    Widget _buildPasswordRow() {
      return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          key: ValueKey('password'),
          controller: _passwordController,
          keyboardType: TextInputType.text,
          textInputAction:
              _isLogin ? TextInputAction.done : TextInputAction.next,
          obscureText: isHiddenPassword,
          focusNode: _passwordFocusNode,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return 'Le mot de passe doit inclure au moins 6 caractères';
            }
          },
          onFieldSubmitted: (_) {
            if (!_isLogin) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
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
                      )),
            labelText: 'Mot de passe',
          ),
        ),
      );
    }

    Widget _buildConfirmPasswordRow() {
      return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          key: ValueKey('password_confirmation'),
          keyboardType: TextInputType.text,
          obscureText: isHiddenPassword,
          focusNode: _confirmPasswordFocusNode,
          validator: !_isLogin
              ? (value) {
                  if (value != _passwordController.text) {
                    return "Les mots de passes ne sont pas identiques";
                  }
                  return null;
                }
              : null,
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
                      )),
            labelText: 'Confirmez mot de passe',
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
                    onPressed: _submit, //todo: _trySubmit,
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
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                signInWithGoogle();
              },
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
        ),
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
                      ),
                    ),
                    Expanded(child: _buildNameRow()),
                    Expanded(child: _buildEmailRow()),
                    Expanded(child: _buildPasswordRow()),
                    SizedBox(
                      height: 5,
                    ),
                    if (!_isLogin) Expanded(child: _buildConfirmPasswordRow()),

                    ///if (_isLogin) Expanded(child: _buildForgetPasswordButton()),
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
      print("double infinity is " + double.infinity.toString());
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(children: [
                      TextSpan(
                        text: _isLogin
                            ? 'Vous n\'avez pas de compte? '
                            : 'Vous êtes déja inscrit? ',
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
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
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
        ),
      ),
    );
  }

  _togglePassword() {
    print('tapped before to show $isHiddenPassword');

    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
    print('tapped after to show $isHiddenPassword');
  }
}
