import 'package:flutter/material.dart';
import 'package:meetup_bloc/widgets.dart';

class StageTwoScreen extends StatelessWidget {
  const StageTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fase 2: Service'),
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
