import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetup_bloc/products.dart';
import 'package:meetup_bloc/stage2.dart';
import 'package:meetup_bloc/widgets.dart';
import 'package:solid_bloc/solid_bloc.dart';
import 'package:uuid/uuid.dart';

class StageFourScreen extends StatefulWidget {
  const StageFourScreen({Key? key}) : super(key: key);

  @override
  _StageFourScreenState createState() => _StageFourScreenState();
}

class _StageFourScreenState extends State<StageFourScreen> {
  late final DocumentReference<Map<String, dynamic>> reference;

  @override
  void initState() {
    super.initState();
    reference = FirebaseFirestore.instance.collection('products').doc('stage4');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(FBProductService()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Fase 4: Solid Bloc'),
          ),
          body: SolidBlocBuilder<ProductBloc>(
            builders: {
              ProductLoadingState: (context, state) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              ProductOverviewState: (context, state) {
                state as ProductOverviewState;
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (Product product in state.products) ...[
                          ProductListing(
                            product: product,
                            onDelete: (product) => context
                                .read<ProductBloc>()
                                .add(ProductDeleteEvent(product)),
                            onUpdate: (product) => context
                                .read<ProductBloc>()
                                .add(ProductUpdateEvent(product)),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          floatingActionButton: AddButton(onProductCreated: (product) {
            BlocProvider.of<ProductBloc>(context).add(ProductAddEvent(product));
          }),
        ),
      ),
    );
  }
}

class ProductBloc extends SolidBloc {
  ProductService productService;

  ProductBloc(this.productService) : super(ProductLoadingState()) {
    withListener((ProductUpdateEvent event, bloc) async =>
        productService.updateProduct(event.product));
    withListener((ProductDeleteEvent event, bloc) async =>
        productService.removeProduct(event.product));
    withListener((ProductAddEvent event, bloc) async =>
        productService.addProduct(event.product));

    withTransition(
        (ProductLoadedEvent event) => ProductOverviewState(event.products));

    productService.init();
    productService.getProductsAsStream().listen((products) {
        this.add(ProductLoadedEvent(products));
    });
  }

  @override
  Future<void> close() {
    productService.dispose();
    return super.close();
  }
}

abstract class ProductState extends SolidBlocState {
  @override
  List<Object?> get props => [];
}

class ProductLoadingState extends ProductState {}

class ProductOverviewState extends ProductState {
  final List<Product> products;

  ProductOverviewState(this.products);
  @override
  List<Object?> get props => [products.hashCode];
}

abstract class ProductEvent extends SolidBlocEvent {}

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
