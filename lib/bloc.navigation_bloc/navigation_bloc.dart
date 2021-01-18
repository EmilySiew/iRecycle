import 'package:bloc/bloc.dart';
import '../pages/myaccountspage.dart';
import '../pages/myorderspage.dart';
//import '../category/paperpage.dart';
//import '../category/metalpage.dart';
//import '../category/plasticpage.dart';
//import '../category/glasspage.dart';

import '../pages/homepage.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
  //MyPaperClickedEvent,
  //MyMetalClickedEvent,
  //MyPlasticClickedEvent,
  //MyGlassClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield MyOrdersPage();
        break;
      /*case NavigationEvents.MyPaperClickedEvent:
        yield PaperPage();
        break;
      case NavigationEvents.MyMetalClickedEvent:
        yield MetalPage();
        break;
      case NavigationEvents.MyPlasticClickedEvent:
        yield PlasticPage();
        break;
      case NavigationEvents.MyGlassClickedEvent:
        yield GlassPage();
        break;*/
    }
  }
}