import 'package:bloc_base_app/app_init_bloc.dart';
import 'package:bloc_base_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc_base/bloc_base.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final bloc = AppInitBloc();
    bloc.emitEvent(InitEvent.appStarted(1));
    return BlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
