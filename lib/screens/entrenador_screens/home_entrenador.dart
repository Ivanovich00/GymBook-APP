import 'dart:io';

import 'package:GymBook/screens/entrenador_screens/export_screens.dart';
import 'package:GymBook/screens/entrenador_screens/help.dart';
import 'package:GymBook/screens/entrenador_screens/widget_entrenador/tarjetas_paginas.dart';
import 'package:GymBook/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:GymBook/screens/screens.dart';

String? userdoc_entrenador;

bool _isNewNotification = false;
bool _isNotificationScreen = false;

bool _isOscuro = false;
bool _isConnectedBool = true;
bool _isIntro = false;
bool _isDialog = false;

String? nombreControl_entrenador, apellidoControl_entrenador, emailControl_entrenador;

class EntrenadorScreen extends StatefulWidget {
  @override
  State<EntrenadorScreen> createState() => _EntrenadorScreenState();
}

class _EntrenadorScreenState extends State<EntrenadorScreen> {
  @override
  void initState() {
    super.initState();
    _initGetDetails();
  }

  Future<void> _initGetDetails() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;

    userdoc_entrenador = user!.uid;

    final authService = Provider.of<AuthService>(context, listen: false);
    final valor_isOscuro = await authService.readTheme();

    if (valor_isOscuro == 'OSCURO') {
      _isOscuro = true;
    } else {
      _isOscuro = false;
    }

    final valor_isIntro = await authService.readIntro();

    if (valor_isIntro == 'TRUE') {
      _isIntro = true;
    } else {
      _isIntro = false;
    }

    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _isConnectedBool = true;
      }
    } catch (_) {
      _isConnectedBool = false;
    }

    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('notificaciones')
            .doc(userdoc_entrenador)
            .collection('nuevas')
            .get()
            .then((value) {
          if (value.docs.length != 0) {
            _isNewNotification = true;
          } else {
            _isNewNotification = false;
          }

          setState(() {});
        });
      }
    } catch (_) {
      Get.snackbar(
        "Error", // title
        "No hay conexión a Internet", // message
        icon: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(Icons.wifi_off_rounded, color: Colors.white),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        shouldIconPulse: true,
        barBlur: 0,
        isDismissible: true,
        duration: Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red[800],
        maxWidth: 350,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      );
    }
  }

  @override 
  Widget build (BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Material(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Scaffold(
                appBar: AppBar(
                  leading: Center(
                    child: Image.asset(
                      'assets/app_icon_transparent.png',
                      fit: BoxFit.fill,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(72, 83, 98, 1),
                  title: Text("Las Barras GYM",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white
                      )
                    )
                  ),
                ),
                body: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Background(),
                    _HomeBody(),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: Tooltip(
                        message: "Ayuda",
                        child: Material(
                          color: Colors.transparent,
                          child: new InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            splashColor: Colors.white38,
                            onTap: () {
                              _isDialog = true;
                              setState(() {});
                            },
                            child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(48, 48, 48, 0.75),
                                    ),
                                  ),
                                  Icon(Icons.help, size: 25, color: Colors.white),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: (_isDialog),
              maintainState: false,
              maintainAnimation: false,
              maintainSize: false,
              maintainSemantics: false,
              maintainInteractivity: false,
              child: GestureDetector(
                onTap: (){
                  _isDialog = false;
                  setState(() {});
                },
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  width: width,
                  height: height,
                ),
              ),
            ),
            Visibility(
              visible: (_isDialog),
              maintainState: false,
              maintainAnimation: false,
              maintainSize: false,
              maintainSemantics: false,
              maintainInteractivity: false,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                width: 250,
                height: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "¿Necesitas ayuda?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Color.fromARGB(255, 49, 49, 49), fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 15),
                    Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color.fromRGBO(107, 195, 130, 1))),
                child: Material(
                  color: Colors.transparent,
                  child: new InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    splashColor: Colors.white38,
                    onTap: () async {
                      _isDialog = false;

                      try {
                        final result = await InternetAddress.lookup('example.com');
      
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("entrenadores")
                                .doc(userdoc_entrenador)
                                .snapshots()
                                .listen((event) {
                              nombreControl_entrenador = event.get('nombre').toString();
                              apellidoControl_entrenador =
                                  event.get('apellido').toString();
                              emailControl_entrenador = event.get('email').toString();
      
                              setState(() {});
      
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: PantallaHelpEntrenador(nombreControl_entrenador: nombreControl_entrenador, apellidoControl_entrenador: apellidoControl_entrenador, emailControl_entrenador: emailControl_entrenador),                                      duration: Duration(milliseconds: 250)));
                            });
                          }
                        }
                      } catch (e) {
                        Get.snackbar(
                          "Error", // title
                          "No hay conexión a Internet", // message
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(Icons.wifi_off_rounded, color: Colors.white),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          snackStyle: SnackStyle.FLOATING,
                          snackPosition: SnackPosition.BOTTOM,
                          shouldIconPulse: true,
                          barBlur: 0,
                          isDismissible: true,
                          duration: Duration(seconds: 3),
                          colorText: Colors.white,
                          backgroundColor: Colors.red[800],
                          maxWidth: 350,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 225,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      child: Icon(Icons.headset_mic_outlined,
                                          size: 27,
                                          color:
                                              Color.fromRGBO(107, 195, 130, 1)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5),
                              Text('Contactanos', style: TextStyle(fontFamily: 'Poppins', fontStyle: FontStyle.normal, fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "Introducción",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontFamily: 'Poppins', fontStyle: FontStyle.normal, fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54),
                    ),
                  SizedBox(width: 10),
                  CupertinoSwitch(
                    trackColor: Colors.black26,
                    value: _isIntro,
                    onChanged: (bool value) async {
                      _isIntro = !_isIntro;
                      if(value == true){
                        await storage.write(key: 'INTRO', value: 'TRUE');
                      } else {
                        await storage.write(key: 'INTRO', value: 'FALSE');
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
      
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
}


class _HomeBody extends StatelessWidget {
  const _HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children:[
          TarjetasOpciones(),
        ],
      ),
    );
  }
}

