import 'dart:io';
import 'dart:ui';

import 'package:GymBook/screens/administrador_screens/calendario_screen.dart';
import 'package:GymBook/screens/administrador_screens/chat_screen.dart';
import 'package:GymBook/screens/administrador_screens/export_screens.dart';
import 'package:GymBook/screens/administrador_screens/usuarios_screen.dart';
import 'package:GymBook/screens/login_screen.dart';
import 'package:GymBook/screens/screens.dart';
import 'package:GymBook/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

bool _isOscuro = false;
String selecciono = '';
String? userdoc;

bool _visto = false;

class TarjetasOpciones extends StatefulWidget {
  @override
  State<TarjetasOpciones> createState() => _TarjetasOpcionesState();
}

class _TarjetasOpcionesState extends State<TarjetasOpciones> {

  Future<void> _initGetDetails() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;

    userdoc = user!.uid;

    final authService = Provider.of<AuthService>(context, listen: false);
    final valor_isOscuro = await authService.readTheme();

    if (valor_isOscuro == 'OSCURO') {
      _isOscuro = true;
    } else {
      _isOscuro = false;
    }

    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty && userdoc != "jqNOu8dCGeOwrKnPYrcKLSuPUmq1") {

        try {
          var docSnap = await FirebaseFirestore.instance.collection("chats").doc('tipo').collection('entrenadores').doc(userdoc).get();
          Map<String, dynamic> data = docSnap.data()!;
          if(data['visto'] == true){
            setState(() {
              _visto = true;
            });
          } else {
            setState(() {
              _visto = false;
            });
          }
        } catch (e) {
          setState(() {
            _visto = true;
          });
        }
                        
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
  
  _actualizarChat() async {
     try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty && userdoc != "jqNOu8dCGeOwrKnPYrcKLSuPUmq1") {

        try {
          var docSnap = await FirebaseFirestore.instance.collection("chats").doc('tipo').collection('entrenadores').doc(userdoc).get();
          Map<String, dynamic> data = docSnap.data()!;
          if(data['visto'] == true){
            setState(() {
              _visto = true;
            });
          } else {
            setState(() {
              _visto = false;
            });
          }
        } catch (e) {
          setState(() {
            _visto = true;
          });
        }
                        
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

  Future<void> _getPage() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;

    String userdoc = user!.uid;

    final authService = Provider.of<AuthService>(context, listen: false);
    final valor_isOscuro = await authService.readTheme();

    if (valor_isOscuro == 'OSCURO') {
      _isOscuro = true;
    } else {
      _isOscuro = false;
    }

    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(userdoc).get().then((DocumentSnapshot documentSnapshot) {
          String user_data = documentSnapshot.data().toString();

          if (user_data.contains('administrador')) {
            if(selecciono == 'usuarios'){
              _actualizarChat();
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: PantallaUsuarios(), duration: Duration(milliseconds: 500)));
            } else if(selecciono == 'ejercicios'){
              _actualizarChat();
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: PantallaEjercicios(), duration: Duration(milliseconds: 500)));
            } else if(selecciono == 'chat'){
              if(userdoc != 'jqNOu8dCGeOwrKnPYrcKLSuPUmq1'){
                _actualizarChat();
                FirebaseFirestore.instance.collection('chats').doc('tipo').collection('entrenadores').doc(userdoc).set({
                  "visto": true,
                });

                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: PantallaChatAdmin(), duration: Duration(milliseconds: 500)));
              } else {
                Get.snackbar(
                  "Cuenta administrativa", // title
                  "Lo sentimos, esta cuenta al ser administrativa no puede realizar esta funcion...", // message
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.error, color: Colors.white),
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
            } else if(selecciono == 'perfil'){
              _actualizarChat();
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: PantallaCuenta(), duration: Duration(milliseconds: 500)));
            } else if(selecciono == 'calendario'){
              _actualizarChat();
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: PantallaCalendario(), duration: Duration(milliseconds: 500)));
            }
          } else {
            authService.logout();
            Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: LoginScreen(), duration: Duration(milliseconds: 500)));
            Get.snackbar(
        "Sesion Cerrada", // title
        "Por favor, vuelve a iniciar sesion", // message
        icon: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(Icons.error, color: Colors.white),
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
  void initState() {
    super.initState();
    _initGetDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Table(children: [
      TableRow(
        children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(48, 48, 48, 0.75),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Material(
              color: Colors.transparent,
              child: new InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                splashColor: Colors.white38,
                  onTap: () {
                    selecciono = 'usuarios';
                    _getPage();
                  },
                  child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
            
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(107, 195, 130, 1),
                            Color.fromRGBO(107, 195, 130, 1),
                            Color.fromRGBO(96, 195, 132, 1),
                            Color.fromRGBO(93, 190, 139, 0.75),
                            Color.fromRGBO(70, 144, 112, 0.75),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                          )
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            child: Icon(Icons.people,
                              size: 30, color: Colors.white),
                          ),
                        ),
                      ),
            
                      SizedBox(
                        height: 10,
                      ),
                      Text('Usuarios',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(48, 48, 48, 0.75),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Material(
              color: Colors.transparent,
              child: new InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                splashColor: Colors.white38,
                  onTap: () {
                    selecciono = 'ejercicios';
                    _getPage();
                  },
                  child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
            
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(82, 154, 186, 1),
                            Color.fromRGBO(70, 145, 172, 1),
                            Color.fromRGBO(69, 139, 171, 1),
                            Color.fromRGBO(62, 129, 152, 1),
                            Color.fromRGBO(60, 119, 144, 1),
                            Color.fromRGBO(51, 107, 127, 1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                          )
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            child: Icon(Icons.fitness_center_sharp,
                              size: 30, color: Colors.white),
                          ),
                        ),
                      ),
            
                      SizedBox(
                        height: 10,
                      ),
                      Text('Ejercicios',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)))
                    ],
              ),
            ),
          ),
        ),
      ),),
      ]
    ),

      TableRow(
        children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(48, 48, 48, 0.75),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Material(
              color: Colors.transparent,
              child: new InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                splashColor: Colors.white38,
                  onTap: () {
                    selecciono = 'chat';
                    _getPage();
                  },
                  child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
            
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(251, 206, 81, 1),
                                      Color.fromRGBO(232, 190, 78, 1),
                                      Color.fromRGBO(232, 167, 35, 1),
                                      Color.fromRGBO(232, 150, 16, 1),
                                      Color.fromRGBO(217, 150, 16, 1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                child: Icon(Icons.chat_rounded,
                                    size: 32, color: Colors.white),
                              ),
                            ),
                          ),
                          if (_visto == false)
                            Positioned(
                              right: 2.5,
                              top: 2.5,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                              ),
                            )
                        ],
                      ),
            
                      SizedBox(
                        height: 10,
                      ),
                      Text('Chat',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(48, 48, 48, 0.75),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Material(
              color: Colors.transparent,
              child: new InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                splashColor: Colors.white38,
                  onTap: () {
                    selecciono = 'perfil';
                    _getPage();
                  },
                  child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
            
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(113, 108, 190, 1),
                            Color.fromRGBO(100, 94, 173, 1),
                            Color.fromRGBO(95, 84, 152, 1),
                            Color.fromRGBO(77, 58, 112, 1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                          )
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            child: Icon(Icons.person_rounded,
                              size: 30, color: Colors.white),
                          ),
                        ),
                      ),
            
                      SizedBox(
                        height: 10,
                      ),
                      Text('Mi Perfil',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white)))
                    ],
              ),
            ),
          ),
        ),
      ),),
      ]
    ),

    TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(48, 48, 48, 0.75),
                borderRadius: BorderRadius.circular(20)),
            child: Material(
              color: Colors.transparent,
              child: new InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                splashColor: Colors.white38,
                onTap: () {
                  selecciono = 'calendario';
                  _getPage();
                },
                child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(150, 150, 150, 1),
                                  Color.fromRGBO(135, 135, 135, 1),
                                  Color.fromRGBO(117, 117, 117, 1),
                                  Color.fromRGBO(94, 94, 94, 1),
                                  Color.fromRGBO(76, 76, 76, 1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            child: Icon(Icons.calendar_today_rounded,
                                size: 30, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Calendario',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(48, 48, 48, 0.75),
                borderRadius: BorderRadius.circular(20)),
            child: Material(
              color: Colors.transparent,
              child: new InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                splashColor: Colors.white38,
                onTap: () {
                  alertaSalir(context);
                },
                child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(181, 96, 90, 1),
                                  Color.fromRGBO(201, 85, 86, 1),
                                  Color.fromRGBO(191, 83, 93, 1),
                                  Color.fromRGBO(178, 80, 111, 1),
                                  Color.fromRGBO(157, 80, 138, 1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            child: Icon(Icons.logout_rounded,
                                size: 30, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Cerrar Sesion',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    ]);
  }

  alertaSalir(BuildContext context) {
    Get.defaultDialog(
      title: 'Cerrar Sesión',
      titlePadding: EdgeInsets.all(15),
      titleStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 19.0,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('¿Estas seguro de cerrar la sesión actual?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black
                )
              )
            )
          ],
        ),
      ),
      barrierDismissible: false,
      radius: 15.0,
      confirm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.red)
              )
            )
          ),
          child: Text("SI"),
          onPressed: () {
            final authService = Provider.of<AuthService>(context, listen: false);
            authService.logout();
            Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: LoginScreen(), duration: Duration(milliseconds: 500)));
          },
        ),
      ),
      cancel: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.black)))),
          child: Text("NO"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}