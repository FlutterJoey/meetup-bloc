import 'package:cloud_firestore/cloud_firestore.dart';
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
  late final DocumentReference<Map<String, dynamic>> reference;

  @override
  void initState() {
    super.initState();
    reference = FirebaseFirestore.instance.collection('products').doc('stage1');
    () async {
      var result = await _loadProducts();
      setState(() {
        products = result;
      });
    }();
  }

  Future<void> _updateProducts() async {
    var rawProducts =
        products.asMap().map((key, value) => MapEntry(value.id, value.toMap()));
    reference.set(rawProducts);
  }

  Future<List<Product>> _loadProducts() async {
    var snap = await reference.get();
    if (snap.exists) {
      return snap
              .data()
              ?.map((key, value) => MapEntry(key, Product.fromMap(key, value)))
              .values
              .toList() ??
          [];
    } else {
      return [];
    }
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
                        setState(() {
                          this.products.remove(product);
                          _updateProducts();
                        });
                      },
                      onUpdate: (product) {
                        setState(() {});
                        _updateProducts();
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: AddButton(onProductCreated: (product) {
        setState(() {
          products.add(product);
          _updateProducts();
        });
      }),
    );
  }
}
