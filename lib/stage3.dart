import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meetup_bloc/products.dart';
import 'package:meetup_bloc/stage2.dart';
import 'package:meetup_bloc/widgets.dart';

class StageThreeScreen extends StatefulWidget {
  const StageThreeScreen({Key? key}) : super(key: key);

  @override
  _StageThreeScreenState createState() => _StageThreeScreenState();
}

class _StageThreeScreenState extends State<StageThreeScreen> {
  late final DocumentReference<Map<String, dynamic>> reference;

  @override
  void initState() {
    super.initState();
    reference = FirebaseFirestore.instance.collection('products').doc('stage4');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) {
        var service = FBProductService();
        var bloc = ProductBloc(service);
        service.init();
        service.getProductsAsStream().listen((event) {
          bloc.add(ProductLoadedEvent(service.getProducts()));
        });
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fase 3: Basis Bloc'),
        ),
        floatingActionButton: Builder(builder: (context) {
          return AddButton(onProductCreated: (product) {
            BlocProvider.of<ProductBloc>(context).add(ProductAddEvent(product));
          });
        }),
        body: Builder(
          builder: (context) {
            return BlocBuilder<ProductBloc, ProductState>(
                builder: (buildContext, blocstate) {
              if (blocstate is ProductLoadingState) {
                return CircularProgressIndicator();
              }
              if (blocstate is ProductOverviewState) {
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (Product product in blocstate.products) ...[
                          ProductListing(
                            product: product,
                            onDelete: (product) =>
                                BlocProvider.of<ProductBloc>(context)
                                    .add(ProductDeleteEvent(product)),
                            onUpdate: (product) =>
                                BlocProvider.of<ProductBloc>(context)
                                    .add(ProductUpdateEvent(product)),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            });
          },
        ),
      ),
    );
  }
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._productService) : super(ProductLoadingState());
  ProductService _productService;

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductLoadedEvent) yield ProductOverviewState(event.products);
  }

  @override
  void onEvent(ProductEvent event) {
    super.onEvent(event);
    if (event is ProductAddEvent) {
      this._productService.addProduct(event.product);
    }
    if (event is ProductDeleteEvent) {
      this._productService.removeProduct(event.product);
    }
    if (event is ProductUpdateEvent) {
      this._productService.updateProduct(event.product);
    }
  }

  @override
  Future<void> close() {
    _productService.dispose();
    return super.close();
  }
}

abstract class ProductState {}

class ProductLoadingState extends ProductState {}

class ProductOverviewState extends ProductState {
  List<Product> products;

  ProductOverviewState(this.products);
}

abstract class ProductEvent {}

class ProductLoadedEvent extends ProductEvent {
  final List<Product> products;

  ProductLoadedEvent(this.products);
}

class ProductUpdateEvent extends ProductEvent {
  final Product product;

  ProductUpdateEvent(this.product);
}

class ProductDeleteEvent extends ProductEvent {
  final Product product;

  ProductDeleteEvent(this.product);
}

class ProductAddEvent extends ProductEvent {
  final Product product;

  ProductAddEvent(this.product);
}
