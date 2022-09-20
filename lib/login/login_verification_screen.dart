import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../generated/l10n.dart';
import '../graphql/generated/graphql_api.graphql.dart';
import '../main/bloc/jwt_cubit.dart';

class VerificationId {
  String? verificationId;
  String? mobileNumber;
  VerificationId({this.verificationId, this.mobileNumber});
}

class LogInVerificationScreen extends StatefulWidget {
  const LogInVerificationScreen({Key? key}) : super(key: key);

  @override
  State<LogInVerificationScreen> createState() =>
      _LogInVerificationScreenState();
}

class _LogInVerificationScreenState extends State<LogInVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  TextEditingController _otpController = TextEditingController();
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VerificationId are =
        ModalRoute.of(context)!.settings.arguments as VerificationId;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Mutation(
            options: MutationOptions(
                document:
                    LoginMutation(variables: LoginArguments(firebaseToken: ""))
                        .document),
            builder: (runMutation, result) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      "Verification",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "google_fonts/DaysOne-Regular.ttf",
                      ),
                    ),
                    Text(
                      "We have sent you an SMS on +91 ${are.mobileNumber} with a 6 digit verification code (OTP).",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffACACAC),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Text(
                      "Enter Code",
                      style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: PinCodeTextField(
                        backgroundColor: Colors.transparent,
                        textInputAction: TextInputAction.done,
                        showCursor: false,
                        pinTheme: PinTheme(
                          borderRadius: BorderRadius.circular(5),
                          shape: PinCodeFieldShape.box,
                          fieldHeight:
                              MediaQuery.of(context).size.height * 0.06,
                          fieldWidth: MediaQuery.of(context).size.width * 0.12,
                          activeColor: Colors.green,
                          borderWidth: 1,
                          inactiveColor: Colors.grey,
                        ),
                        keyboardType: TextInputType.number,
                        appContext: context,
                        length: 6,
                        onChanged: (String value) {},
                        controller: _otpController,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: (result?.isLoading == true)
                            ? null
                            : () {
                                if (_otpController.text.length < 6) {
                                  final snackBar = SnackBar(
                                    content: Text(
                                      S
                                          .of(context)
                                          .verify_phone_code_empty_message,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  return;
                                }
                                login(_otpController.text, runMutation,
                                    are.verificationId);
                              },
                        child: Center(
                          child: Text(
                            S.of(context).verify,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Center(
                      child: Text(
                        "Didn't receive the code?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff292929),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.yellow,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Update Phone Number",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void login(
      String code, RunMutation runMutation, String? verificationId) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: code);
    final UserCredential cr =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final String firebaseToken = await cr.user!.getIdToken();
    final QueryResult qe =
        await runMutation({"firebaseToken": firebaseToken}).networkResult!;
    final String jwt = Login$Mutation.fromJson(qe.data!).login.jwtToken;
    final Box box = await Hive.openBox('user');
    box.put("jwt", jwt);
    context.read<JWTCubit>().login(jwt);
    if (!mounted) return;
    Navigator.of(context).pushNamed("profileScreen");
  }
}
