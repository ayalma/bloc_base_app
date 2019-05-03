import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_base_app/app_init_bloc.dart';
import 'package:bloc_base_app/check_version_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InitState oldState;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppInitBloc>(context);
    return StateBuilder<InitEvent, InitState>(
      bloc: bloc,
      builder: (BuildContext context, state) {
        print(state.runtimeType);
        if (oldState != state) {
          oldState = state;
          switch (state.runtimeType) {
            case CheckVersionState:
              _redirectToPage(context, CheckVersionScreen());
          }
        }
        // This page does not need to display anything since it will
        // always remind behind any active page (and thus 'hidden').
        return Container();
      },
    );
  }

  void _redirectToPage(BuildContext context, Widget page){
    WidgetsBinding.instance.addPostFrameCallback((_){
      MaterialPageRoute newRoute = MaterialPageRoute(
          builder: (BuildContext context) => page
      );

      Navigator.of(context).pushAndRemoveUntil(newRoute, ModalRoute.withName('/splash'));
    });
  }
}
