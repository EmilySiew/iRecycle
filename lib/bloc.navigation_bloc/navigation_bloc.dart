import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../pages/myaccountspage.dart';
import '../pages/myorderspage.dart';
import 'package:recycle/user.dart';

//import '../category/paperpage.dart';
//import '../category/metalpage.dart';
//import '../category/plasticpage.dart';
//import '../category/glasspage.dart';

import '../pages/homepage.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  final User user;
  NavigationBloc({@required this.user});

  @override
  NavigationStates get initialState => HomePage(user: user);

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage(user: user);
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
