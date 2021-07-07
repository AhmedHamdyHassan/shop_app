import 'package:flutter/foundation.dart';

class CartItem{
  final String id,title;
  final double price;
  final int quantity;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity
  });
}

class Cart with ChangeNotifier{
  Map<String,CartItem>_items={};

  Map<String,CartItem> get item{
    return {..._items};
  }

  int get cartItemNumber{
    return _items.length;
  }

  double get totalPrice{
    double total=0.0;
    _items.forEach((key, value)=>total+=value.quantity*value.price);
    return total;
  }

  void addItem(String id,double price,String title){
    if(_items.containsKey(id)){
      _items.update(
        id, 
        (value) => CartItem(
          id: value.id, 
          title: value.title, 
          price: value.price, 
          quantity: value.quantity+1
        )
      );
    }else{
      _items.putIfAbsent(
        id, 
        () => CartItem(
          id: DateTime.now().toString(), 
          title: title, 
          price: price, 
          quantity: 1
        )
      );
    }
    notifyListeners();
  }
  void removeByID(String id){
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id){
    if(!_items.containsKey(id)){
      return;
    }
    if(_items[id].quantity>1){
      _items.update(id, (value) => CartItem(
        id: value.id, 
        title: value.title, 
        price: value.price, 
        quantity: value.quantity-1)
      );
    }else{
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear(){
    _items={};
    notifyListeners();
  }
}