import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetup_bloc/products.dart';

class AddButton extends StatelessWidget {
  final void Function(Product) onProductCreated;
  const AddButton({Key? key, required this.onProductCreated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        var product = await showDialog<Product>(
            context: context,
            builder: (ctx) {
              return CreateProductDialog();
            });
        if (product != null) {
          onProductCreated.call(product);
        }
      },
      child: Icon(Icons.add),
    );
  }
}

class CreateProductDialog extends StatefulWidget {
  const CreateProductDialog({Key? key}) : super(key: key);

  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  String? error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Container(
      width: _screenSize.width,
      height: _screenSize.height,
      alignment: Alignment.center,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxHeight: 500,
            maxWidth: 300,
          ),
          child: Column(
            children: [
              Text(
                'Add product',
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(height: 10),
              if (this.error != null) ...[
                Text(error!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.redAccent)),
                Container(height: 10),
              ],
              Container(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                        child: Text('Name',
                            style: Theme.of(context).textTheme.bodyText1)),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 10),
              Container(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                        child: Text('Price',
                            style: Theme.of(context).textTheme.bodyText1)),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _priceController,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 10),
              Container(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                        child: Text('Stock',
                            style: Theme.of(context).textTheme.bodyText1)),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _stockController,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  double? price = double.tryParse(
                      _priceController.text.replaceAll(',', '.'));
                  int? stock = int.tryParse(_stockController.text);
                  String text = _nameController.text;

                  if (text.isNotEmpty && price != null && stock != null) {
                    Navigator.of(context).pop(Product(
                      name: text,
                      price: price,
                      stock: stock,
                    ));
                  } else {
                    setState(() {
                      error = 'Not all fields are filled in correctly.';
                    });
                  }
                },
                icon: Icon(Icons.add),
                label:
                    Text('Add', style: Theme.of(context).textTheme.bodyText2),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}

class ProductListing extends StatelessWidget {
  final Product product;
  final void Function(Product) onDelete;
  const ProductListing({Key? key, required this.product, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name', style: Theme.of(context).textTheme.bodyText1),
                  Text(product.name, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.price_check),
                  Text(
                      product.price.toString().substring(
                          0,
                          min(product.price.toString().lastIndexOf('.') + 3,
                              product.price.toString().length)),
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.store),
                  Text(product.stock.toString(),
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
