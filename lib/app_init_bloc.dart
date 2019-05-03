import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_base_app/app_version.dart';

class InitEvent extends BlocEvent {
  final int buildNumber;
  final InitEventType eventType;

  InitEvent(this.eventType, {this.buildNumber});

  factory InitEvent.serverSettingSavedEvent() =>
      InitEvent(InitEventType.ServerSettingSave);

  factory InitEvent.serverSettingReset() =>
      InitEvent(InitEventType.ServerSettingReset);

  factory InitEvent.introPageSeen() => InitEvent(InitEventType.IntroPageSeen);

  factory InitEvent.appStarted(int buildNumber) =>
      InitEvent(InitEventType.AppStarted, buildNumber: buildNumber);

  factory InitEvent.login() => InitEvent(InitEventType.AuthLogin);

  factory InitEvent.logout() => InitEvent(InitEventType.AuthLogout);

  factory InitEvent.checkVersionDone() =>
      InitEvent(InitEventType.checkVersionDone);
}

enum InitEventType {
  AppStarted,
  ServerSettingSave,
  ServerSettingReset,
  IntroPageSeen,
  checkVersionDone,
  AuthLogin,
  AuthLogout,
}

abstract class InitState extends BlocState {}

class someClass extends InitState {
  final InitStateType stateType;

  someClass(this.stateType);

  factory someClass.processing() => someClass(InitStateType.processing);

  factory someClass.introPage() => someClass(InitStateType.introPage);

  factory someClass.serverSetting() => someClass(InitStateType.serverSetting);

  factory someClass.main() => someClass(InitStateType.main);

  factory someClass.auth() => someClass(InitStateType.auth);

  factory someClass.checkVersion() => someClass(InitStateType.checkVersion);
}

class CheckVersionState extends InitState {
  final Status status;
  final AppVersion appVersion;
  final Error error;

  CheckVersionState(this.status, this.appVersion, this.error);

  factory CheckVersionState.loading() => CheckVersionState(Status.Loading, null, null);
  factory CheckVersionState.success(AppVersion appVersion) => CheckVersionState(Status.Success, appVersion, null);
  factory CheckVersionState.error(Object error) => CheckVersionState(Status.Error, null, error);
}

enum InitStateType {
  processing,
  introPage,
  serverSetting,
  main,
  auth,
  checkVersion,
}

class AppInitBloc extends EventStateBaseBloc<InitEvent, InitState> {
  AppInitBloc() : super(initialState: someClass.processing());

  @override
  Stream<InitState> mapEventToState(
      InitEvent event, InitState currentState) async* {
    switch (event.eventType) {
      case InitEventType.AppStarted:
        yield someClass.processing();

        /// The place to decide witch page must be showed to user
        /// we can use currentState to determine what to do .
        ///
        ///if intro page seen by user . there is no need to show it again
        ///if server setting saved there is no need to show it
        ///then after all above checks done . we must show check version page for showing version to user
        ///and if checking was successful emit an event to bloc
        ///and we can emmit reset setting event to.
        /// and so on
        yield CheckVersionState.loading();

        //simulate api call
        await Future.delayed(Duration(seconds: 5));

        if(false) {
          yield CheckVersionState.success(AppVersion(1, '', ''));
          break;
        }
        /// if access token is here we must navigate to main page
        /// else navigate to login page
        //yield someClass.main(); // or
        //yield someClass.auth();


        break;
      case InitEventType.checkVersionDone:

        ///if checking version was ok
        break;
      case InitEventType.IntroPageSeen:

        /// init page is showed to user and user hit the next button so we must
        /// save a flag to storage to determine that the init page is seen by user and we must don't show that page again
        yield someClass.processing();
        break;
      case InitEventType.ServerSettingSave:

        /// server setting is change in because of that we must clear access token too
        /// and redirect user to login page
        break;
      case InitEventType.ServerSettingReset:

        /// server setting cleared and for that we must navigate to server setting page.
        break;
      case InitEventType.AuthLogin:

        /// this event telling us the application has been login ,
        /// and server address is saved and also intro page is shown to user
        break;
      case InitEventType.AuthLogout:

        /// user event we must check user cardinals with remote server and after that if login was successful
        /// navigate to main page ...
        /// and we must show server processing status and also error to user in proper place
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
