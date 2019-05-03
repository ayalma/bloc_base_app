import 'dart:io';

import 'package:bloc_flutter/bloc_flutter.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_base_app/app_init_bloc.dart';
import 'package:flutter/material.dart';

class CheckVersionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppInitBloc>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: StateBuilder<InitEvent, InitState>(
          bloc: bloc,
          builder: (context, InitState state) {
            final checkVersionState = state as CheckVersionState;
            switch (checkVersionState.status) {
              case Status.Loading:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case Status.Error:
                return Center(
                  child: Text(checkVersionState.error.toString()),
                );
                break;
              case Status.Success:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('New Version Available'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('download'),
                              onPressed: () {
                                // todo : call download method or
                              },
                              textTheme: ButtonTextTheme.accent,
                            ),
                            FlatButton(
                              child: Text('cancel'),
                              onPressed: () {
                                exit(0);
                              },
                            ),
                          ],
                        );
                      });
                });
                return Container(); // this never hit i guess
                break;
            }
          }),
    );
  }
}
