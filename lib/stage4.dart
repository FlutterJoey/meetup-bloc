import 'package:flutter/material.dart';
import 'package:meetup_bloc/widgets.dart';

class StageFourScreen extends StatelessWidget {
  const StageFourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fase 4: Solid Bloc'),
      ),
      body: Container(
          // list products
          // add delete button
          // add product through button,
          ),
      floatingActionButton: AddButton(onProductCreated: (product) {}),
    );
  }
}
