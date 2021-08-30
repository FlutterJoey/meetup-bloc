import 'package:flutter/material.dart';

mixin SlideMixin<T extends StatefulWidget> on State<T> {
  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 20),
      ),
    );
  }
}

class SlideStart extends StatefulWidget {
  const SlideStart({ Key? key }) : super(key: key);

  @override
  _SlideStartState createState() => _SlideStartState();
}

class _SlideStartState extends State<SlideStart> with SlideMixin {
  @override
  Widget build(BuildContext context) {
    return Slide(
      children: [
        _title('Meetup Flutter BLoC'),
      ],
    );
  }
}

class SlideOne extends StatefulWidget {
  const SlideOne({Key? key}) : super(key: key);

  @override
  _SlideOneState createState() => _SlideOneState();
}

class _SlideOneState extends State<SlideOne> with SlideMixin {
  @override
  Widget build(BuildContext context) {
    return Slide(
      children: [
        _title('Fase 1: Null Safety, SetState & Domein'),
        _header('Null Safety'),
        _paragraph(' - Voordelen'),
        _paragraph(' - Migrating Legacy code'),
        _header('Bad Practice: SetState'),
        _header('Domein: Waar moet de logica?'),
      ],
    );
  }
}

class SlideTwo extends StatefulWidget {
  const SlideTwo({Key? key}) : super(key: key);

  @override
  _SlideTwoState createState() => _SlideTwoState();
}

class _SlideTwoState extends State<SlideTwo> with SlideMixin {
  @override
  Widget build(BuildContext context) {
    return Slide(
      children: [
        _title('Fase 2: Services'),
        _header('Waarom services'),
        _paragraph(' - Testbaar'),
        _paragraph(' - Implementatie Onafhankelijk'),
        _header('Wanneer services'),
        _paragraph(' - Domeinlogica'),
        _paragraph(' - Asynchrone applicaties'),
      ],
    );
  }
}

class SlideThree extends StatefulWidget {
  const SlideThree({ Key? key }) : super(key: key);

  @override
  _SlideThreeState createState() => _SlideThreeState();
}

class _SlideThreeState extends State<SlideThree> with SlideMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class SlideFour extends StatefulWidget {
  const SlideFour({ Key? key }) : super(key: key);

  @override
  _SlideFourState createState() => _SlideFourState();
}

class _SlideFourState extends State<SlideFour> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class Slide extends StatelessWidget {
  final List<Widget> children;
  const Slide({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
