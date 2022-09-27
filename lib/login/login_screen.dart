import 'package:client_shared/config.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:ridy/generated/l10n.dart';
import 'package:ridy/login/login_verification_screen.dart';
import 'package:ridy/main/bloc/jwt_cubit.dart';
import '../graphql/generated/graphql_api.graphql.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String phoneNumber = "";

  String countryCode = !kIsWeb
      ? (CountryCodes.detailsForLocale().dialCode ?? defaultCountryCode)
      : defaultCountryCode;

  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    "images/markertuktuk.png",
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome to TukTuk Electric",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "google_fonts/DaysOne-Regular.ttf",
                    ),
                  ),
                  Text(
                    "Please provide your mobile number. Your phone number will be used for all ride related messages and OTP.",
                    style: TextStyle(
                      color: Color(0xffACACAC),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter your Mobile Number",
                    style: TextStyle(
                      color: Color(0xff464646),
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      prefixIcon: CountryCodePicker(
                        boxDecoration: BoxDecoration(
                            color: CustomTheme.neutralColors.shade100,
                            borderRadius: BorderRadius.circular(10)),
                        initialSelection: countryCode,
                        onChanged: (code) => countryCode = code.dialCode!,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xff29BF79))),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xff29BF79))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xff29BF79))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xff29BF79))),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      hintText: S.of(context).login_cell_number_textfield_hint,
                    ),
                    onChanged: (value) => phoneNumber = value,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).login_cell_number_empty_error;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Mutation(
                    options: MutationOptions(document: LOGIN_MUTATION_DOCUMENT),
                    builder: (MultiSourceResult<Object?> Function(
                                Map<String, dynamic>,
                                {Object? optimisticResult})
                            runMutation,
                        QueryResult<Object?>? result) {
                      return GestureDetector(
                        onTap: !agreedToTerms &&
                                loginTermsAndConditionsUrl.isNotEmpty
                            ? null
                            : () async {
                                if (!kIsWeb) {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: countryCode + phoneNumber,
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) async {
                                      final UserCredential cr =
                                          await FirebaseAuth.instance
                                              .signInWithCredential(credential);
                                      final String firebaseToken =
                                          await cr.user!.getIdToken();
                                      final QueryResult qe = await runMutation(
                                              {"firebaseToken": firebaseToken})
                                          .networkResult!;
                                      final String jwt =
                                          Login$Mutation.fromJson(qe.data!)
                                              .login
                                              .jwtToken;

                                      final Box box =
                                          await Hive.openBox('user');
                                      box.put("jwt", jwt);
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                      context.read<JWTCubit>().login(jwt);
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) async {
                                      if (e.message != null) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: Text(e.message!),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  S.of(context).action_ok,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }

                                      await FirebaseCrashlytics.instance
                                          .recordError(e, e.stackTrace,
                                              reason: 'Login error');
                                    },
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      Navigator.of(context).pushNamed(
                                        "loginVerificationCodeView",
                                        arguments: VerificationId(
                                          verificationId: verificationId,
                                          mobileNumber: phoneNumber,
                                        ),
                                      );
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {},
                                  );
                                } else {
                                  //Navigator.pop(context);
                                  final result = await FirebaseAuth.instance
                                      .signInWithPhoneNumber(
                                          countryCode + phoneNumber,
                                          RecaptchaVerifier(onSuccess: () {}));
                                  if (!mounted) return;
                                  Navigator.of(context).pushNamed(
                                    "loginVerificationCodeView",
                                    arguments: VerificationId(
                                      verificationId: result.verificationId,
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffF4D206),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text("or"),
                      Expanded(
                        child: new Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Login with Social Accounts",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.green,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              'images/icons8-google.png',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.green,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              'images/apple.png',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.green,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              'images/icons8-facebook.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
