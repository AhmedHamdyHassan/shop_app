import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const String screenKey='/cart_screen';
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('My Cart'),),
      body: Column(children: <Widget>[
        Container(margin: EdgeInsets.all(10),
        child:Card(
          child: Padding(padding: EdgeInsets.all(8),child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Total',style: TextStyle(fontSize: 25),),
              Spacer(),
              Chip(
                label: Text('\$${cart.totalPrice.toStringAsFixed(2)}',style: TextStyle(
                  color:Theme.of(context).textTheme.bodyText1.color,)),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              OrderFlatButton(cart: cart)
            ],
          ),
        ),),
        ),
        Expanded(
          child:ListView.builder(
            itemBuilder: (ctx,i)=>CartItem(
              id: cart.item.values.toList()[i].id, 
              title: cart.item.values.toList()[i].title, 
              price: cart.item.values.toList()[i].price, 
              quantity: cart.item.values.toList()[i].quantity,
              productID: cart.item.keys.toList()[i],
            ),
            itemCount: cart.item.length,
          )
        )
      ],),
    );
  }
}

class OrderFlatButton extends StatefulWidget {

  OrderFlatButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderFlatButtonState createState() => _OrderFlatButtonState();
}

class _OrderFlatButtonState extends State<OrderFlatButton> {
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    final errorDialog=AlertDialog(
          title: Text('Error'),
          content: Text('Something wrong happened when connecting with the server!'),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('OK'))
          ],
        );
    return FlatButton(
      onPressed:widget.cart.totalPrice<=0? null:()async{
        setState(() {
          _isLoading=true;
        });
        try{
          await Provider.of<Order>(context,listen: false).addOrder(
            widget.cart.item.values.toList(), 
            widget.cart.totalPrice
          );
          widget.cart.clear();
        }catch(error){
          await showDialog(context: context,builder:(_)=>errorDialog);
        }
        setState(() {
          _isLoading=false;
        });
      }, 
      child:_isLoading? CircularProgressIndicator():Text(
        'ORDER NOW',
        style: TextStyle(fontWeight: FontWeight.bold)
      ),
      textColor:Theme.of(context).primaryColor,
    );
  }
}