import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetup_bloc/app_presentation.dart';
import 'package:meetup_bloc/slides.dart';
import 'package:meetup_bloc/stage1.dart';
import 'package:meetup_bloc/stage2.dart';
import 'package:meetup_bloc/stage3.dart';
import 'package:meetup_bloc/stage4.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext? buildContext;
  String currentSlide = 'start';

  @override
  void initState() {
    super.initState();
    var store = FirebaseFirestore.instance;
    store
        .collection('presentations')
        .doc('meetup-bloc')
        .snapshots()
        .listen((event) {
      if (event.exists && buildContext != null && mounted) {
        String slide = event.get('slide');
        moveToSlide(slide, buildContext!);
      }
    });
  }

  void moveToSlide(String slide, BuildContext context) async {
    if (this.currentSlide != slide) {
      this.currentSlide = slide;

      await FirebaseFirestore.instance
          .collection('presentations')
          .doc('meetup-bloc')
          .update({'slide': slide});
      Navigator.of(context).pushReplacementNamed(slide);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {
      'start': (context) => AppPresentation(
            explanation: SlideStart(),
            image: Image.asset(
              'assets/images/presentation_start.png',
              fit: BoxFit.contain,
            ),
            onNext: () => moveToSlide('stage1', context),
          ),
      'stage1': (context) => AppPresentation(
            app: StageOneScreen(),
            explanation: SlideOne(),
            onNext: () => moveToSlide('stage2', context),
          ),
      'stage2': (context) => AppPresentation(
            app: StageTwoScreen(),
            explanation: SlideTwo(),
            onNext: () => moveToSlide('stage3', context),
            onPrevious: () => moveToSlide('stage1', context),
          ),
      'stage3': (context) => AppPresentation(
            app: StageThreeScreen(),
            explanation: SlideThree(),
            onNext: () => moveToSlide('stage4', context),
            onPrevious: () => moveToSlide('stage2', context),
          ),
      'stage4': (context) => AppPresentation(
            app: StageFourScreen(),
            explanation: SlideFour(),
            onPrevious: () => moveToSlide('stage3', context),
          ),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.montserrat().copyWith(fontSize: 50),
          headline3: GoogleFonts.montserrat().copyWith(fontSize: 34),
          bodyText1: GoogleFonts.raleway(),
          bodyText2: GoogleFonts.raleway(),
        ),
        primarySwatch: Colors.blueGrey,
      ),
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) {
            buildContext = context;
            return routes[settings.name]!.call(context);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
      },
      initialRoute: 'start',
    );
  }
}
