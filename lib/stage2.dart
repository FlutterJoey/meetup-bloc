import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetup_bloc/products.dart';
import 'package:meetup_bloc/widgets.dart';

class StageTwoScreen extends StatefulWidget {
  final ProductService productService;
  const StageTwoScreen({Key? key, required this.productService})
      : super(key: key);

  @override
  _StageTwoScreenState createState() => _StageTwoScreenState();
}

class _StageTwoScreenState extends State<StageTwoScreen> {
  late final ProductService _productService;

  @override
  void initState() {
    super.initState();
    _productService = widget.productService;
    _productService.init();
  }

  @override
  void dispose() {
    _productService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fase 2: Service'),
      ),
      body: StreamBuilder<List<Product>>(
          stream: _productService.getProductsAsStream(),
          builder: (context, snapshot) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (Product product in _productService.getProducts()) ...[
                      ProductListing(
                        product: product,
                        onDelete: _productService.removeProduct,
                        onUpdate: _productService.updateProduct,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: AddButton(onProductCreated: (product) {
        _productService.addProduct(product);
      }),
    );
  }
}

abstract class ProductService {
  void addProduct(Product product);

  void updateProduct(Product product);

  List<Product> getProducts();

  Stream<List<Product>> getProductsAsStream();

  void removeProduct(Product product);

  void init();
  void dispose();
}

class FBProductService implements ProductService {
  late final StreamController<List<Product>> _productStreamController;
  late final DocumentReference<Map<String, dynamic>> _productReference;
  List<Product> _products = [];

  @override
  void addProduct(Product product) {
    _productReference.update({product.id: product.toMap()});
  }

  @override
  void dispose() {
    _productStreamController.close();
  }

  @override
  List<Product> getProducts() {
    return _products;
  }

  @override
  Stream<List<Product>> getProductsAsStream() {
    return _productStreamController.stream;
  }

  @override
  void init() {
    _productStreamController = StreamController.broadcast();
    _productReference =
        FirebaseFirestore.instance.collection('products').doc('stage1');
    _productReference.snapshots().listen((event) {
      if (event.exists && !_productStreamController.isClosed) {
        _products = event
            .data()!
            .map((key, value) => MapEntry(key, Product.fromMap(key, value)))
            .values
            .toList();
        _products.sort((a, b) => a.id.compareTo(b.id));
        _productStreamController.add(_products);
      }
    });
  }

  @override
  void removeProduct(Product product) {
    _products.removeWhere((element) => product.id == element.id);
    _productReference.set({
      for (Product product in _products) ...{
        product.id: product.toMap(),
      }
    });
  }

  @override
  void updateProduct(Product product) {
    _productReference.update({product.id: product.toMap()});
  }
}
