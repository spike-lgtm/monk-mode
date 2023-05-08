import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppItem extends StatelessWidget {
  final Application application;
  final bool? isFav;
  final bool focus;
  AppItem({Key? key, required this.application, this.isFav, this.focus = false})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            GestureDetector(
              onTap: () {
                if (focus) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xff3D7086),
                          content: Container(
                            width: 300.0,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Focus Mode: ON!",
                                        style: GoogleFonts.alegreya(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.alegreya(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: 'Please type '),
                                            TextSpan(
                                                text:
                                                    "'${application.appName.toLowerCase()}'",
                                                style: GoogleFonts.alegreya(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: ' to unlock.'),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    child: TextFormField(
                                      validator: (String? input) {
                                        if (input!.toLowerCase() !=
                                            application.appName.toLowerCase()) {
                                          return "Please type app name properly!";
                                        }
                                        return null;
                                      },
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.alegreya(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        errorStyle: GoogleFonts.alegreya(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        hintStyle: GoogleFonts.alegreya(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        hintText: "  ",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffE2DDCF)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        application.openApp();
                                      }
                                    },
                                    child: Text(
                                      "Unlock",
                                      style: GoogleFonts.alegreya(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  application.openApp();
                }
              },
              child: Text(application.appName,
                  style: GoogleFonts.alegreya(
                    color: Colors.white70,
                    fontSize: 28,
                  )),
            ),
          ]),
          if (isFav != null)
            GestureDetector(
              onTap: () {},
              child: AnimatedContainer(
                  height: 35,
                  width: 120,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                      color: const Color(0x00ffffff),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.shade700,
                      )),
                  child: Center(
                      child: Text(!isFav! ? 'Make Favourite' : 'Remove',
                          style: GoogleFonts.alegreya(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)))),
            )
        ],
      ),
    );
  }
}
