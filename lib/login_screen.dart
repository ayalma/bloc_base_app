import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_base_app/app_init_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_flutter/bloc_flutter.dart';
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppInitBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0,),
            TextField(
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0,),
            RaisedButton.icon(
                onPressed: () {
                  //bloc.emitEvent(AuthLoginEvent());
                },
                icon: Icon(Icons.fitness_center),
                label: Text('login'))
          ],
        ),
      ),
    );
  }
}
