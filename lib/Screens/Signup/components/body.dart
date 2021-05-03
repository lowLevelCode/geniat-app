import 'package:flutter/material.dart';
import 'package:geniant_app/Screens/Signup/components/background.dart';
import 'package:geniant_app/Util/dialogs.dart';
import 'package:geniant_app/Util/response.server.dart';
import 'package:geniant_app/components/rounded_button.dart';
import 'package:geniant_app/components/rounded_input_field.dart';
import 'package:geniant_app/components/rounded_password_field.dart';
import 'package:geniant_app/services/global.service.dart';
// import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController firstname;
  TextEditingController lastname;
  TextEditingController birthdate;
  TextEditingController email;
  TextEditingController password;

  @override
  void initState() {
    super.initState();
    firstname = new TextEditingController();
    lastname = new TextEditingController();
    birthdate = new TextEditingController();
    email = new TextEditingController();
    password = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstname.dispose();
    lastname.dispose();
    birthdate.dispose();
    email.dispose();
    password.dispose();
  }

  void _clearInputs() {
    firstname.clear();
    lastname.clear();
    birthdate.clear();
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "First name",
              controller: firstname,
            ),
            RoundedInputField(
              hintText: "Last name",
              controller: lastname,
            ),
            RoundedInputField(
              hintText: "Birthdate",
              controller: birthdate,
              readOnly: true,
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now())
                    .then((value) => {
                          setState(() =>
                              {birthdate.text = value.toString().split(' ')[0]})
                        });
              },
            ),
            RoundedInputField(
              hintText: "Email",
              controller: email,
            ),
            RoundedPasswordField(
              controller: password,
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () async {
                Map<String, dynamic> registro = {
                  "firstname": firstname.text,
                  "lastname": lastname.text,
                  "birthdate": birthdate.text,
                  "email": email.text,
                  "password": password.text,
                };

                ResponseServer serverResponse =
                    await GlobalService.registrar(registro);

                var message = serverResponse.message;
                var titleDialog = 'Usuario Registrado';

                if (!serverResponse.response) {
                  titleDialog = '¡Alerta!';
                }

                Utility.getInstance()
                    .showAlertDialog(context, titleDialog, '$message.');
                _clearInputs();
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
