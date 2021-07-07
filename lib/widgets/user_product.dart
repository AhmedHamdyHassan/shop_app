import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  final String title,imageUrl,id;
  UserProduct(this.title,this.imageUrl,this.id);
  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
          trailing: Container(
            width: MediaQuery.of(context).size.width/4.2,
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.edit), onPressed: (){
                  Navigator.of(context).pushNamed(EditProductScreen.screenKey,arguments:{'title':'Edit','id':id});
                },color: Theme.of(context).primaryColor,),
                IconButton(icon: Icon(Icons.delete), onPressed: ()async{
                  try{
                    await Provider.of<ProductProvider>(context,listen: false).deleteProduct(id);
                  }catch(error){
                    scaffold.showSnackBar(SnackBar(content:Text(error.toString(),textAlign: TextAlign.center,)));
                  }
                },color: Theme.of(context).errorColor)
              ],
            ),
          ),
        ),
    );
  }
}