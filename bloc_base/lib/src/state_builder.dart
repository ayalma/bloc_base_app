import 'package:bloc_base/src/bloc_event.dart';
import 'package:bloc_base/src/bloc_event_state.dart';
import 'package:bloc_base/src/bloc_state.dart';
import 'package:flutter/widgets.dart';

typedef Widget AsyncStateBuilder<BS extends BlocState>(
    BuildContext context, BS state);

///
/// this must go to separate package because of seprating flutter from core code which can share with other dart project's
/// StateBuilder Widget which allows you to respond to the State(s), emitted by the EventStateBloc.
///
/// This Widget is nothing else but a specialized StreamBuilder, which will invoke the builder input argument each time a new BlocState will be emitted.
///
class StateBuilder<BE extends BlocEvent, BS extends BlocState>
    extends StatelessWidget {
  final EventStateBaseBloc<BE, BS> bloc;
  final AsyncStateBuilder<BS> builder;

  const StateBuilder({Key key, this.bloc, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BS>(
        stream: bloc.state,
        builder: (BuildContext context, AsyncSnapshot<BS> snapshot) {
          return builder(context, snapshot.data);
          /// because of init state this always have data
        });
  }
}
