import 'package:flutter/widgets.dart';
///
/// Generic BLoC provider
///
/// This class will provide bloc for you'r child widget's
/// Just by calling  BlocProvider<T>.of(context) (T is type of you'r bloc)
///
/// I used a StatefulWidget to benefit from its dispose() method
/// To ensure the release of the resources allocated by the BLoC, when no longer necessary.
/// And inherited widget for performance
///
/// ------------------------------------How to use the new BlocProvider ? -------------------------------
///
/// Injection of the BLoC
/// Widget build(BuildContext context){
///     return BlocProvider<MyBloc>{
///         bloc: myBloc,
///         child: ...
///     }
/// }
///
/// Retrieval of the BLoC
/// Widget build(BuildContext context)
/// {
///     MyBloc myBloc = BlocProvider.of<MyBloc>(context);
///     ...
/// }
///
///
///  ----------------------------Where to initialize a BLoC ?-------------------------
///  To answer this question, you need to figure out the scope of its use.
///  1)Available everywhere in the Application
///    Suppose that you have to deal with some mechanisms related to User Authentication/Profile,
///    User Preferences, Shopping Basket… anything that would require a BLoC to be available from potentially
///    any possible parts of an application (eg from different pages), there exists 2 ways of making this BLoC accessible.
///
///    1-1)Use of a Global Singleton
///        This solution relies on the use of a Global object, instantiated once for all, not part of any Widget tree.
///
///        class GlobalBloc extends BaseBloc {
///
///               ///
///               /// Singleton factory
///               /// For accessing bloc instance
///               ///
///               static final GlobalBloc _bloc = GlobalBloc._internal();
///               factory GlobalBloc(){
///                   return _bloc;
///               }
///               GlobalBloc._internal(){
///                   // init  global bloc
///               }
///
///               @override
///               void dispose() {
///                    : dispose impl
///               }
///
///        }
///
///        Like that
///
///        import 'global_bloc.dart';
///        class MyWidget extends StatelessWidget {
///            @override
///            Widget build(BuildContext context){
///             globalBloc.push('building MyWidget');
///              return Container();
///            }
///       }
///     1-2)Position it on top of everything
///         In Flutter, the ancestor of all pages must itself be the parent of the MaterialApp.
///         This is due to the fact that a page (or Route) is wrapped in an OverlayEntry, child of a common Stack for all pages.
///         In other words, each page has a BuildContext which is independent of any other page.
///         This explains why, without using any tricks, it is impossible for 2 pages (Routes) to have anything in common.
///         Therefore, if you need a BLoC to be available anywhere in the application,
///         you have to put it as the parent of the MaterialApp, as follows:
///
///         void main() => runApp(Application());
///         class Application extends StatelessWidget {
///             @override
///             Widget build(BuildContext context) {
///                  return BlocProvider<AuthenticationBloc>(
///                     bloc: AuthenticationBloc(),
///                     child: MaterialApp(
///                         title: 'BLoC Samples',
///                         theme: ThemeData(
///                             primarySwatch: Colors.blue,
///                         ),
///                         home: InitializationPage(),
///                     ),
///                 );
///             }
///         }
///  2) Available to a sub-tree
///     Most of the time, you might need to use a BLoC in some specific parts of the application.
///     As an example, we could think of a discussion thread where the BLoC will be used to
///       # interact with the Server to retrieve, add, update posts
///       # list the threads to be displayed in a certain page
///       # …
///
///     For this example, you do not need this BLoC to be available to the whole application but to some Widgets,
///     part of a tree.
///
///     class MyTree extends StatefulWidget {
///       @override
///     _ MyTreeState createState() => _MyTreeState();
///     }
///     class _MyTreeState extends State<MyTree>{
///       MyBloc bloc;
///       @override
///       void initState(){
///         super.initState();
///         bloc = MyBloc();
///       }
///       @override
///       void dispose(){
///         bloc?.dispose();
///         super.dispose();
///       }
///       @override
///       Widget build(BuildContext context){
///         return BlocProvider<MyBloc>(
///           bloc: bloc,
///           child: Column(
///             children: <Widget>[
///               MyChildWidget(),
///             ],
///           ),
///         );
///       }
///     }
///
///   Note that using StatelessWidget is not optimal as it will instantiate the BLoC each time it will rebuild.
///   Consequences:
///     you will lose any existing content of the BLoC
///     it will cost CPU time as it needs to instantiate it at each build.
///  3)  Available to only one Widget
///    This relates to cases where a BLoC would only be used by only one Widget.
///    In this case, it is acceptable to instantiate the BLoC inside the Widget.
///

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const BlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  }) : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BaseBloc>(BuildContext context) {
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }
}

class _BlocProviderState<T extends BaseBloc> extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return new _BlocProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

///
/// BlocProvider Inherited widget
///The context.ancestorWidgetOfExactType() is a O(n) function.
/// In order to retrieve the requested ancestor that corresponds to a certain type,
/// it navigates up the tree, starting from the context and recursively goes up one parent at a time,
/// until completion. If the distance from the context to the ancestor is small, the call to this function is acceptable,
/// otherwise it should be avoided. Here is the code of this function.
///
/// and for that we use combine of inherited widget and stateful widget
///
///
/// The advantage is this solution is performance.
/// Thanks to the use of an InheritedWidget,
/// it may now call the context.ancestorInheritedElementForWidgetOfExactType() function, which is a O(1),
/// meaning that the retrieval of the ancestor is immediate, as shown by its source code:
///
class _BlocProviderInherited<T> extends InheritedWidget {
  final T bloc;

  const _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_BlocProviderInherited old) => false;
}

Type _typeOf<T>() => T;
