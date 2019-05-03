import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_base_app/app_init_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_flutter/bloc_flutter.dart';
class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppInitBloc>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Intro Page',
              style: theme.textTheme.display1,
            ),
            SizedBox(
              height: 8.0,
            ),
            RaisedButton(
              child: Text('next page'),
              onPressed: () {
                bloc.emitEvent(InitEvent.introPageSeen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
