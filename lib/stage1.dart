import 'package:flutter/material.dart';
import 'package:meetup_bloc/products.dart';
import 'package:meetup_bloc/widgets.dart';

class StageOneScreen extends StatefulWidget {
  const StageOneScreen({Key? key}) : super(key: key);

  @override
  _StageOneScreenState createState() => _StageOneScreenState();
}

class _StageOneScreenState extends State<StageOneScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    () async {
      var result = await _loadProducts();
      setState(() {
        products = result;
      });
    }();
  }

  Future<List<Product>> _loadProducts() async {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fase 1: Null Safety & Domein'),
      ),
      body: Container(
        // list products
        // add delete button
        // add product through button,
        child: SingleChildScrollView(
          child: Column(
            children: products
                .map((e) => ProductListing(
                      product: e,
                      onDelete: (product) {
                        this.products.remove(product);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: AddButton(onProductCreated: (product) {
        setState(() {
          products.add(product);
        });
      }),
    );
  }
}
