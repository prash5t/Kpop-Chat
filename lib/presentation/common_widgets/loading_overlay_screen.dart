import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlayScreen extends StatelessWidget {
  const LoadingOverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
        child: SafeArea(
          child: Stack(
            children: [
              const Center(
                child: SpinKitCircle(color: Colors.black),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white.withOpacity(0),
              ),
            ],
          ),
        ));
  }
}
