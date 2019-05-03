import 'dart:async';
import 'package:bloc_base/src/base_bloc.dart';
import 'package:bloc_base/src/bloc_event.dart';
import 'package:bloc_base/src/bloc_state.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import "package:rxdart/rxdart.dart";

///
/// Sometimes, handling a series of activities which might be sequential or parallel,
/// long or short, synchronous or asynchronous and which could also lead to various results,can become extremely hard to program.
/// You might also require to update the display along with the progress or depending on the states.
///
/// This first use case is aimed at making it easier to handle such situation.
///
/// This solution is based on the following principle:
///   an event is emitted;
///   this event triggers some action which leads to one or several states;
///   each of these states could in turn emit other events or lead to another state;
///   these events would then trigger other action(s), based on the active state;
///   and so on…
/// In order to illustrate this concept, let’s take 2 common examples:
///   Application initialization
///     Suppose that you need to run a series of actions to initialize an application.
///     Actions might be linked to interactions with a server (eg to load some data).
///     During this initialization process,
///     you might need to display a progress bar together with a series of images to make the user wait.
///   Authentication
///     At start up, an application might require a user to authenticate or to register.
///     Once the user is authenticated, the user is redirected to the main page of the
///     application. Then, if the user signs out, he is redirected to the authentication page.
///  In order to be able to handle all possible cases,
///  sequence of events but also if we consider that events could be triggered anywhere in the application,
///  this might become quite hard to manage.
///  This is where the EventStateBloc, combined with a EventStateBuilder, can help a lot…
///
abstract class EventStateBaseBloc<BE extends BlocEvent, BS extends BlocState>
    implements BaseBloc {
  ///event emitting controller
  PublishSubject<BE> _eventController = PublishSubject<BE>();
  BehaviorSubject<BS> _stateController = BehaviorSubject<BS>();

  ///
  /// For emitting event to bloc
  ///
  Function(BE) get emitEvent => _eventController.sink.add;

  ///
  /// Current/New state
  ///
  Stream<BS> get state => _stateController.stream;

  ///
  /// for mapping event to state
  ///
  Stream<BS> mapEventToState(BE event, BS currentState);

  ///
  /// initialState
  ///
  final BS initialState;


  EventStateBaseBloc({@required this.initialState}) {
    _stateController.sink.add(initialState);
    ///listen to event's emitted from outside
    _eventController.stream.listen((BE event) {
      final currentState = _stateController.value ?? initialState;
      final Stream<BS> blocState = mapEventToState(event, currentState);
      _stateController.addStream(blocState);
    });
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
