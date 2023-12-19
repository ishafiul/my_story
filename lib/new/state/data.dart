import 'package:flutter/foundation.dart';

class StoryDataNotifier<T> extends ChangeNotifier {
  int _value = 0;
  late Iterable<T> _data = [];
  Iterable<T> get data => _data;
  int get value => _value;
  void addData(Iterable<T> data) {
    _data = [..._data,...data];
    notifyListeners();
  }
  void increment() {
    _value++;
    notifyListeners();
  }
  /*@override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
    super.addListener(listener);
  }*/
}