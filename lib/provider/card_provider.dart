import 'package:flutter/material.dart';

class CardProvider extends ChangeNotifier {
  List<String> _urlImages = [];
  bool _isDragging = false;

  bool get isDragging => _isDragging;
  int count = 0;
  double _angle = 0;
  Offset _position = Offset.zero;

  Offset get position => _position;
  Size _screenSize = Size.zero;

  double get angle => _angle;

  List<String> get urlImages => _urlImages;

  void setScreenSize(Size screenSize) {
    _screenSize = screenSize;
    notifyListeners();
  }

  CardProvider() {
    resetUsers();
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x = position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    resetPosition();
    notifyListeners();
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  void resetUsers() {
    {
      _urlImages = [
        "https://upload.wikimedia.org/wikipedia/commons/0/06/Tr%C3%BAc_Anh_%E2%80%93_M%E1%BA%AFt_bi%E1%BA%BFc_BTS_%282%29.png",
        "https://s1.media.ngoisao.vn/resize_580/news/2021/05/13/kim-ngan6-ngoisaovn-w660-h824.jpg",
        "https://anhdep123.com/wp-content/uploads/2021/02/hinh-nen-gai-xinh-full-hd-cho-dien-thoai.jpg",
      ];
      notifyListeners();
    }
  }

  void increment() {
    count++;
    notifyListeners();
  }
}
