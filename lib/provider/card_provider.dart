import 'package:flutter/material.dart';

enum CardStatus { like, dislike, superLike }

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
    final status = getStatus();
    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }

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
      _urlImages = <String>[
        "https://www.vietnamairlinesgiare.vn/wp-content/uploads/2015/12/ve-may-bay-di-london-1-28-12-2015.png",
        "https://s1.media.ngoisao.vn/resize_580/news/2021/05/13/kim-ngan6-ngoisaovn-w660-h824.jpg",
        "https://anhdep123.com/wp-content/uploads/2021/02/hinh-nen-gai-xinh-full-hd-cho-dien-thoai.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/0/06/Tr%C3%BAc_Anh_%E2%80%93_M%E1%BA%AFt_bi%E1%BA%BFc_BTS_%282%29.png",
      ].reversed.toList();
      notifyListeners();
    }
  }

  void increment() {
    count++;
    notifyListeners();
  }

  CardStatus? getStatus() {
    final x = position.dx;
    final y = position.dy;
    const delta = 100;
    final forceSuperLike = x.abs() <20;

    if (x >= delta) {
      return CardStatus.like;
    }else if(x <= -delta){
      return CardStatus.dislike;
    }else if(y<= -delta /2 && forceSuperLike){
      return CardStatus.superLike;
    }
    return null;
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle =-20;
    _position -= Offset(2* _screenSize.width,0);
    _nextCard();
    notifyListeners();
  }

  void supperLike() {}

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    _urlImages.removeLast();
    resetPosition();
  }
}
