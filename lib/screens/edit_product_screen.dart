import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String screenKey='/edit_product_screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode=FocusNode();
  final _descriptionFocusNode=FocusNode();
  final _imageUrlController=TextEditingController();
  final _imageFocusNode=FocusNode();
  final _form=GlobalKey<FormState>();
  bool _isCorrectLink=true,isIniat=true;
  bool _isLoading=false;
  Map<String,String>data;
  Product _savedProduct=Product(id: null, description: '', imageUrl: '', price: 0, title: '');
  var _editingMapValues={
    'title':'',
    'description':'',
    'price':''
  };

  @override
  void didChangeDependencies() {
    if(isIniat){
      data=ModalRoute.of(context).settings.arguments as Map;
      final id=data['id'];
      if(id!=null){
      _savedProduct=Provider.of<ProductProvider>(context).getByID(id);
      _editingMapValues={
        'title':_savedProduct.title,
        'description':_savedProduct.description,
        'price':_savedProduct.price.toString()
      };
      _imageUrlController.text=_savedProduct.imageUrl;
      }
    }
    isIniat=false;
    super.didChangeDependencies();
  }

  @override
  void initState(){
    _imageFocusNode.addListener(updateImage);
    super.initState();
  }

  @override
  void dispose(){
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.removeListener(updateImage);
    _imageFocusNode.dispose();
    super.dispose();
  }

  void updateImage(){
    if(!_imageFocusNode.hasFocus){
      if(!_imageUrlController.text.startsWith('http')||
         !_imageUrlController.text.startsWith('https')||
         (!_imageUrlController.text.endsWith('.png')&&
         !_imageUrlController.text.endsWith('.jpg')&&
         !_imageUrlController.text.endsWith('.jpeg'))){
           _isCorrectLink=false;
           setState(() {});
           return;
      }
      _isCorrectLink=true;
      setState(() {});
    }
  }

  Future<void> saveData() async {
    final errorDialog=AlertDialog(
          title: Text('Error'),
          content: Text('Something wrong happened when connecting with the server!'),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('OK'))
          ],
        );
    if(!_form.currentState.validate()){
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading=true;
    });
    if(_savedProduct.id!=null){
      try{
      await Provider.of<ProductProvider>(context,listen: false).updateProduct(_savedProduct.id,_savedProduct);
      }catch(error){
        await showDialog(context: context,builder:(_)=>errorDialog);
      }
    }else{
      try{
      await Provider.of<ProductProvider>(context,listen: false).addProduct(_savedProduct);
      }catch(error){
        await showDialog(context: context,builder:(_)=>errorDialog);
      }
    }
    setState((){
      _isLoading=false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: saveData)
        ],
      ),
      body:_isLoading? Center(child:CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_priceFocusNode);
            },
            initialValue: _editingMapValues['title'],
            onSaved: (value){
              _savedProduct=Product(
                id:_savedProduct.id, 
                description: _savedProduct.description, 
                imageUrl: _savedProduct.imageUrl, 
                price: _savedProduct.price, 
                title: value,
                isFavorite: _savedProduct.isFavorite
              );
            },
            validator: (value){
              if(value==null||value==''){
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Price',
            ),
            focusNode: _priceFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_descriptionFocusNode);
            },
            initialValue: _editingMapValues['price'],
            onSaved: (value){
              _savedProduct=Product(
              id: _savedProduct.id, 
              description: _savedProduct.description, 
              imageUrl: _savedProduct.imageUrl, 
              price: double.parse(value), 
              title: _savedProduct.title,
              isFavorite: _savedProduct.isFavorite
              );
            },
            validator: (value){
              if(value.isEmpty){
                return 'Please enter a price.';
              }else if(double.tryParse(value)==null){
                return 'Please enter a valid price.';
              }else if(double.parse(value)<=0){
                return 'Please enter a value greater than 0.';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            focusNode: _descriptionFocusNode,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            initialValue: _editingMapValues['description'],
            onSaved: (value){
              _savedProduct=Product(
                id:_savedProduct.id, 
                description: value, 
                imageUrl: _savedProduct.imageUrl, 
                price: _savedProduct.price, 
                title: _savedProduct.title,
                isFavorite: _savedProduct.isFavorite
              );
            },
            validator: (value){
              if(value==null||value==''){
                return 'Please enter a Description';
              }else if(value.length<10){
                return 'The description should be at least 10 characters.';
              }
              return null;
            },
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10,right: 10),
                width:MediaQuery.of(context).size.width/4,
                height:MediaQuery.of(context).size.width/4,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 1)),
                child:_isCorrectLink?_imageUrlController.text.isEmpty? Center(child: Text('Enter URL'),):
                Image.network(_imageUrlController.text,fit: BoxFit.cover,):Padding(
                  padding: const EdgeInsets.only(right:5,left: 5),
                  child: Center(child: FittedBox(child:Text('Enter correct URL')),),
                ),
              ),
              Expanded(
                child:TextFormField(
                decoration: InputDecoration(
                  labelText:'Image URL',
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                controller: _imageUrlController,
                focusNode: _imageFocusNode,
                onSaved: (value){
                  _savedProduct=Product(
                    id:_savedProduct.id, 
                    description: _savedProduct.description, 
                    imageUrl: value, 
                    price: _savedProduct.price, 
                    title: _savedProduct.title,
                    isFavorite: _savedProduct.isFavorite
                  );
                },
                onFieldSubmitted: (_)=>saveData(),
                validator: (value){
                  if(value.isEmpty){
                    return 'Please put a URL link';
                  }else if(!value.startsWith('http')&&!value.startsWith('https')){
                    return 'Please enter a valid link';
                  }else if(!value.endsWith('.png')&&!value.endsWith('.jpg')&&!value.endsWith('.jpeg')){
                    return 'The image should be (png,jpg,jpeg) only.';
                  }
                  return null;
                },
              ))
            ],)
        ],)),
      ),
    );
  }
}