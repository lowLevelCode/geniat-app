import 'package:flutter/material.dart';
import 'package:geniant_app/Screens/Login/components/background.dart';
import 'package:geniant_app/Screens/Request/request_screen.dart';
import 'package:geniant_app/Util/dialogs.dart';
import 'package:geniant_app/Util/response.server.dart';
import 'package:geniant_app/components/rounded_button.dart';
import 'package:geniant_app/components/rounded_input_field.dart';
import 'package:geniant_app/components/rounded_password_field.dart';
import 'package:geniant_app/constants.dart';
import 'package:geniant_app/main.dart';
// import 'package:flutter_svg/svg.dart';

import 'package:geniant_app/services/global.service.dart';

class Body extends StatefulWidget {
  Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController email;
  TextEditingController password;

  @override
  void initState() {
    super.initState();
    email = new TextEditingController();
    password = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void _clearInputs() {
    email.clear();
    password.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              controller: email,
            ),
            RoundedPasswordField(
              controller: password,
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                Map<String, dynamic> login = {
                  "email": email.text,
                  "password": password.text
                };

                ResponseServer serverResponse =
                    await GlobalService.login(login);

                var message = serverResponse.message;

                if (!serverResponse.response) {
                  Utility.getInstance()
                      .showAlertDialog(context, '¡Alerta!', '$message.');
                  _clearInputs();
                  return;
                }

                var jwt = await storage.read(key: JWT_KEY);

                if (jwt != '' || jwt != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ResquestScreen();
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
