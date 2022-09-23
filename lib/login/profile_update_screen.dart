import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridy/generated/l10n.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileUpdateScreen extends StatelessWidget {
  String firstName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
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
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(
                          "A",
                          style: TextStyle(
                            color: Color(0xff3B7B3F),
                          ),
                        ),
                        backgroundColor: Color(0xff29BF79).withOpacity(0.2),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xff29BF79),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Center(
                  child: Text(
                    "Awadhut Shah",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "google_fonts/DaysOne-Regular.ttf",
                    ),
                  ).pOnly(left: 16),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "First Name",
                  style: TextStyle(
                    color: Color(0xffACACAC),
                    fontSize: 14,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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
                    hintText: "First Name",
                  ),
                  onChanged: (value) => firstName = value,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).login_cell_number_empty_error;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "Last Name",
                  style: TextStyle(
                    color: Color(0xffACACAC),
                    fontSize: 14,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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
                    hintText: "Last Name",
                  ),
                  onChanged: (value) => firstName = value,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).login_cell_number_empty_error;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "Email ID",
                  style: TextStyle(
                    color: Color(0xffACACAC),
                    fontSize: 14,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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
                    hintText: "Email ID",
                  ),
                  onChanged: (value) => firstName = value,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).login_cell_number_empty_error;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "Your Address",
                  style: TextStyle(
                    color: Color(0xffACACAC),
                    fontSize: 14,
                  ),
                ),
                TextFormField(
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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
                    hintText: "Your Address",
                  ),
                  onChanged: (value) => firstName = value,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).login_cell_number_empty_error;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/marker.png",
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Expanded(
                      child: Text(
                        "Detect My Location to Auto Update",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffD6BB12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("onBoardingScreen");
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Update Profile",
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
                  height: MediaQuery.of(context).size.height * 0.05,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
