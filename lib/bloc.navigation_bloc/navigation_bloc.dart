import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../pages/collecteditem.dart';
import '../pages/recycleitem.dart';
import 'package:recycle/user.dart';
import '../pages/homepage.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  CollectItemClickedEvent,
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
      case NavigationEvents.CollectItemClickedEvent:
        yield CollectItemPage(user: user);
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield RecycleItemPage(user: user);
        break;
    }
  }
}
