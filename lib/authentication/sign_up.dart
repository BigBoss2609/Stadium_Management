import 'package:flutter/material.dart';
import 'package:saha_owner/authentication/init.dart';
import 'package:saha_owner/authentication/sign_up_bloc.dart';
import 'package:saha_owner/component/button/saha_back_button.dart';
import 'package:saha_owner/component/button/saha_button_green.stateless.dart';
import 'package:saha_owner/component/text_field/saha_text_field.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = new TextEditingController();

  TextEditingController phoneController = new TextEditingController();

  TextEditingController passController = new TextEditingController();

  TextEditingController nameController = new TextEditingController();

  SignUpBloc signUpBloc = new SignUpBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(


      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Color(0xFFE54DB63),Color(0xFFE00BFA5)],
                ),
              ),
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: Text(
                        "ĐĂNG KÍ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ))

                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 90),
            child: Container(
              child: SahaBackButton(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 170, left: 20, right: 20, bottom: 25),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: Colors.grey)),
              child: ListView(
                children: <Widget>[
                      Container(
                          child: SahaTextField(
                            controller: nameController,
                              labelText: "Họ và Tên",
                              icon: Icon(Icons.person, color: Colors.green))),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                      Container(
                        child: SahaTextField(
                          controller: passController,
                            labelText: 'Mật khẩu',
                            obscureText: true,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.green,
                            )),
                      ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                      Container(
                          child: SahaTextField(
                            textInputType:TextInputType.emailAddress,
                            controller: emailController,
                        labelText: "Email",
                        icon: Icon(
                          Icons.email,
                          color: Colors.green,
                        ),
                      )),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                      Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: SahaTextField(
                            textInputType:TextInputType.phone,
                          controller: phoneController,
                            labelText: "Số điện thoại",
                            icon: Icon(
                              Icons.phone,
                              color: Colors.green,
                            )),
                      ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  StreamBuilder<Object>(
                    stream: signUpBloc.controlError,
                    builder: (context, snapshot) {
                      return snapshot.hasData ? Center(
                          child: Text(
                        snapshot.data,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )) : Container();
                    }
                  ),
                  StreamBuilder<Object>(
                    stream: signUpBloc.controlLoading,
                    builder: (context, snapshot) {
                      return Container(
                        child: snapshot.hasData && snapshot.data ? Center(
                            child: CircularProgressIndicator()) : SahaButton(
                          onPressed: () {
                            signUpBloc.signUpWithEmailPassword(
                                email: emailController.text,
                                phone: phoneController.text,
                                pass: passController.text,
                                name: nameController.text,
                                success: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Init(),
                                    ),
                                  );
                                  signUpBloc.setLoading(false);
                                },
                                faild: (err) {
                                  signUpBloc.sendError(err);
                                  signUpBloc.setLoading(false);
                                });
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      );
                    }
                  )
                ],
              ),
            ),

          ),
        ],
      ),
    );
  }
}
