import 'dart:math';
import 'package:my_shop/Models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/Providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0); //this is another way of doing the .. thing cuz here the translate method will only edit the transformconfig from inside and doesnt effect the return value of the transformconfig an example of that is the methods of a class , it wont returns a new version of the class but only update the class from inside (editing the object in memory)
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: //transformConfig.translate(-10.0), //explained above
                          Matrix4.rotationZ(-8 * pi / 180)
                            ..translate(
                                -10.0), //translate offsets the object // .. (cascade operator) runs the statement after it (translate) but doesnot return what it returns (void in case of translate) instead it returns what the previous statement in the chain return
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.fastOutSlowIn));
    // _heightAnimation.addListener((() => setState(() {}))); //we can use the animation builder instead of manually putting the listner and to prevent building things which is unrelated to animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An error occurred'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: (() => Navigator.of(context).pop()),
              child: const Text('Okay'))
        ],
      ),
    );
  }

  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['password'], _authData['email']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['password'], _authData['email']);
      }
    } on HttpException catch (e) {
      var errormessage = 'Autentication failed!';
      if (e.toString().contains('EMAIL_EXISTS')) {
        //to string here simply give us the message cuz we override the tostring in http exception
        errormessage = 'The email is already resgistered';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errormessage = 'This is not a valid email address';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errormessage = 'This password is too weak';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errormessage = 'Could not find a user with that email';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errormessage = 'Wrong password';
      }
      _showErrorDialog(errormessage);
    } catch (e) {
      const errormessage = 'could not authenticate you, pls try again later';
      _showErrorDialog(errormessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
          //using this approach instead of animated builder is better for single objects animations cuz it will make the animation controller and object automatically with the changing values
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          // height: _heightAnimation.value.height,
          height: _authMode == AuthMode.Signup ? 340 : 290,
          constraints: //A constraint is just a set of 4 doubles: a minimum and maximum width, and a minimum and maximum height
              BoxConstraints(
                  minHeight: //_heightAnimation.value.height
                      _authMode == AuthMode.Signup ? 340 : 290),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),

          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  AnimatedContainer(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 300),
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(TextStyle(
                            color: Theme.of(context).colorScheme.secondary))
                        // ,foregroundColor:MaterialStateProperty.all(Theme.of(context).colorScheme.secondary)
                        ,
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                        ),
                      ),
                      onPressed: _submit,
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    ),
                  TextButton(
                    onPressed: _switchAuthMode,
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                        )),
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  )
                ],
              ),
            ),
          ),
        )
        // child: AnimatedBuilder(
        //   //here only the builder (container) which is wanted to be animated will be rebuilt
        //   animation: _heightAnimation,
        //   builder: ((context, child) => Container(
        //       height: _heightAnimation.value.height,
        //       // height: _authMode == AuthMode.Signup ? 320 : 260,
        //       constraints: //A constraint is just a set of 4 doubles: a minimum and maximum width, and a minimum and maximum height
        //           BoxConstraints(
        //               minHeight: _heightAnimation
        //                   .value.height //_authMode == AuthMode.Signup ? 320 : 260
        //               ),
        //       width: deviceSize.width * 0.75,
        //       padding: const EdgeInsets.all(16.0),
        //       child: child)),
        //   child: Form(
        //     key: _formKey,
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: <Widget>[
        //           TextFormField(
        //             decoration: const InputDecoration(labelText: 'E-Mail'),
        //             keyboardType: TextInputType.emailAddress,
        //             validator: (value) {
        //               if (value!.isEmpty || !value.contains('@')) {
        //                 return 'Invalid email!';
        //               }
        //               return null;
        //             },
        //             onSaved: (value) {
        //               _authData['email'] = value!;
        //             },
        //           ),
        //           TextFormField(
        //             decoration: const InputDecoration(labelText: 'Password'),
        //             obscureText: true,
        //             controller: _passwordController,
        //             validator: (value) {
        //               if (value!.isEmpty || value.length < 5) {
        //                 return 'Password is too short!';
        //               }
        //               return null;
        //             },
        //             onSaved: (value) {
        //               _authData['password'] = value!;
        //             },
        //           ),
        //           if (_authMode == AuthMode.Signup)
        //             TextFormField(
        //               enabled: _authMode == AuthMode.Signup,
        //               decoration:
        //                   const InputDecoration(labelText: 'Confirm Password'),
        //               obscureText: true,
        //               validator: _authMode == AuthMode.Signup
        //                   ? (value) {
        //                       if (value != _passwordController.text) {
        //                         return 'Passwords do not match!';
        //                       }
        //                       return null;
        //                     }
        //                   : null,
        //             ),
        //           const SizedBox(
        //             height: 20,
        //           ),
        //           if (_isLoading)
        //             const CircularProgressIndicator()
        //           else
        //             ElevatedButton(
        //               style: ButtonStyle(
        //                 textStyle: MaterialStateProperty.all(TextStyle(
        //                     color: Theme.of(context).colorScheme.secondary))
        //                 // ,foregroundColor:MaterialStateProperty.all(Theme.of(context).colorScheme.secondary)
        //                 ,
        //                 backgroundColor: MaterialStateProperty.all(
        //                     Theme.of(context).colorScheme.primary),
        //                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(30))),
        //                 padding: MaterialStateProperty.all(
        //                   const EdgeInsets.symmetric(
        //                       horizontal: 30.0, vertical: 8.0),
        //                 ),
        //               ),
        //               onPressed: _submit,
        //               child:
        //                   Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
        //             ),
        //           TextButton(
        //             onPressed: _switchAuthMode,
        //             style: ButtonStyle(
        //                 textStyle: MaterialStateProperty.all(TextStyle(
        //                     color: Theme.of(context).colorScheme.secondary)),
        //                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //                 padding: MaterialStateProperty.all(
        //                   const EdgeInsets.symmetric(
        //                       horizontal: 30.0, vertical: 8.0),
        //                 )),
        //             child: Text(
        //                 '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
