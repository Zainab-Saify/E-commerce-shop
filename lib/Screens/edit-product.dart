import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var pricefocusNode = FocusNode();
  var discriptionFocusNode = FocusNode();
  final imgUrlController = TextEditingController();
  var urlFocusNode = FocusNode();
  var isLoading = false;
  Product p;

  String url;
  var form = GlobalKey<FormState>();
  var edittedProduct =
      Product(description: '', imageUrl: '', price: 0.0, title: '');

  void dispose() {
    pricefocusNode.dispose();
    discriptionFocusNode.dispose();
    urlFocusNode.dispose();
    imgUrlController.dispose();
    super.dispose();
  }

  Future<void> submitForm(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    form.currentState.save();
    var products = Provider.of<Products>(context, listen: false);
    try {
      await products.addItem(edittedProduct);
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Error Occured'),
                content: Text('opps, Something went wrong!'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay!'))
                ],
              )).then((_) {
        Navigator.of(context).pop();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      if (p != null) {
        products.deleteItem(p.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    p = ModalRoute.of(context).settings.arguments;
    if (p != null) edittedProduct = p;

    //url = edittedProduct.imageUrl;
    return Scaffold(
      appBar: AppBar(
        title: Text(p == null ? 'Add Product' : 'Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => submitForm(context),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: edittedProduct.title,
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (title) {
                        FocusScope.of(context).requestFocus(pricefocusNode);
                      },
                      onSaved: (value) => {
                        edittedProduct = Product(
                            id: edittedProduct.id,
                            description: edittedProduct.description,
                            imageUrl: edittedProduct.imageUrl,
                            price: edittedProduct.price,
                            isFav: edittedProduct.isFav,
                            title: value)
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return "Title is a required field";
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      initialValue: edittedProduct.price.toString(),
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: pricefocusNode,
                      onFieldSubmitted: (price) {
                        FocusScope.of(context)
                            .requestFocus(discriptionFocusNode);
                      },
                      onSaved: (value) => {
                        edittedProduct = Product(
                            id: edittedProduct.id,
                            description: edittedProduct.description,
                            imageUrl: edittedProduct.imageUrl,
                            isFav: edittedProduct.isFav,
                            price: double.parse(value),
                            title: edittedProduct.title)
                      },
                      validator: (value) {
                        if (double.tryParse(value) <= 0.0 || value.isEmpty)
                          return "This is not a valid Input";
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      initialValue: edittedProduct.description,
                      decoration: InputDecoration(labelText: "Discription"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: discriptionFocusNode,
                      onFieldSubmitted: (discription) {
                        FocusScope.of(context).requestFocus(urlFocusNode);
                      },
                      onSaved: (value) => {
                        edittedProduct = Product(
                            id: edittedProduct.id,
                            description: value,
                            imageUrl: edittedProduct.imageUrl,
                            price: edittedProduct.price,
                            isFav: edittedProduct.isFav,
                            title: edittedProduct.title)
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return "Discription of product is needed";
                        else
                          return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          padding: EdgeInsets.only(top: 5, right: 10),
                          decoration: BoxDecoration(),
                          child: imgUrlController.text.isEmpty
                              ? Container(
                                  color: Colors.grey,
                                  child: Center(child: Text('invalid url')))
                              : FittedBox(
                                  child: Image(
                                    image: NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Container(
                          width: 250,
                          height: 100,
                          child: TextFormField(
                            initialValue: edittedProduct.imageUrl,
                            decoration: InputDecoration(labelText: "Image URL"),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            focusNode: urlFocusNode,
                            onTap: () {},
                            onChanged: (newUrl) {
                              setState(() {
                                url = newUrl;
                              });
                            },
                            onSaved: (value) => {
                              edittedProduct = Product(
                                  id: edittedProduct.id,
                                  description: edittedProduct.description,
                                  imageUrl: value,
                                  price: edittedProduct.price,
                                  isFav: edittedProduct.isFav,
                                  title: edittedProduct.title)
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Provide few images for your product';
                              else
                                return null;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 40,
                      width: 60,
                      child: FittedBox(
                        child: RaisedButton(
                          child: Text(
                            p == null ? 'submit!' : 'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepOrange,
                          onPressed: () => submitForm(context),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
