import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({
    Key? key,
     required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _PurpleBox(),

          const _HeaderIcon(),

          child,

        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  //Nota, este constructor fue hecho extrayendo solo el widget de SafeArea
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SafeArea es por si un dispositivo tiene un notch, el contenido se siga viendo bien
    return SafeArea(
        child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100)
        ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4, //40%
      decoration: _buildBoxDecoration(),

      //burbujas de fondo
      child: Stack(
        children: const[
          Positioned(child: _Bubble(), top: 60, left: 10,),
          Positioned(child: _Bubble(), top: -40, left: -30,),
          Positioned(child: _Bubble(), top: -50, right: -20,),
          Positioned(child: _Bubble(), top: 90, left: 150,),
          Positioned(child: _Bubble(), bottom: 50, right: 30,),
          Positioned(child: _Bubble(), bottom: -50, left: 30,),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(255, 195, 0, 1),
          Color.fromRGBO(255, 195, 0, 1)
        ]
      )
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.3)
      ),
    );
  }
}