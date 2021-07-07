import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id,title,productID;
  final double price;
  final int quantity;
  CartItem({this.id,this.price,this.quantity,this.title,this.productID});
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        child: Icon(Icons.delete,size: 40,color: Colors.white,),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        padding: EdgeInsets.only(right: 20),
      ),
      onDismissed: (item){
        cart.removeByID(productID);
      },
      confirmDismiss: (direction){
        return showDialog(context: context,builder: (ctx)=>AlertDialog(
          title: Text('Are you sure?',style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text('Do you want to delete this product?'),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(ctx).pop(false);
            }, child: Text('No',style: TextStyle(fontWeight: FontWeight.bold))),
            FlatButton(onPressed: (){
              Navigator.of(ctx).pop(true);
            }, child: Text('Yes',style: TextStyle(fontWeight: FontWeight.bold)))
          ],
        ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child:Padding(padding:EdgeInsets.all(5),child: FittedBox(child: Text('\$$price'),))
            ),
            title: Text(title,style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Total:\$${(quantity*price)}',style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text('${quantity}X',style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ),
      ),
    );
  }
}