import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_base_app/app_init_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_flutter/bloc_flutter.dart';
class ServerSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppInitBloc>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Setting save'),
            onPressed: (){
              bloc.emitEvent(InitEvent.serverSettingSavedEvent());
            },
          ),
        ],
      ),
    );
  }
}
