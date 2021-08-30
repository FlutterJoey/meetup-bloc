import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetup_bloc/app_presentation.dart';
import 'package:meetup_bloc/slides.dart';
import 'package:meetup_bloc/stage1.dart';
import 'package:meetup_bloc/stage2.dart';
import 'package:meetup_bloc/stage3.dart';
import 'package:meetup_bloc/stage4.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {
      'start': (context) => AppPresentation(explanation: SlideStart(), image: Image.asset('assets/images/presentation_start.png', fit: BoxFit.contain,)),
      'stage1': (context) => AppPresentation(
            app: StageOneScreen(),
            explanation: SlideOne(),
            onNext: () => Navigator.of(context).pushReplacementNamed('stage2'),
          ),
      'stage2': (context) => AppPresentation(
            app: StageTwoScreen(),
            explanation: SlideTwo(),
            onNext: () => Navigator.of(context).pushReplacementNamed('stage3'),
            onPrevious: () =>
                Navigator.of(context).pushReplacementNamed('stage1'),
          ),
      'stage3': (context) => AppPresentation(
            app: StageThreeScreen(),
            explanation: SlideOne(),
            onNext: () => Navigator.of(context).pushReplacementNamed('stage4'),
            onPrevious: () =>
                Navigator.of(context).pushReplacementNamed('stage2'),
          ),
      'stage4': (context) => AppPresentation(
            app: StageFourScreen(),
            explanation: SlideOne(),
            onPrevious: () =>
                Navigator.of(context).pushReplacementNamed('stage3'),
          ),
    };

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.montserrat().copyWith(fontSize: 40),
          headline3: GoogleFonts.montserrat().copyWith(fontSize: 24),
          bodyText1: GoogleFonts.raleway(),
          bodyText2: GoogleFonts.raleway().copyWith(color: Colors.white),
        ),
        primarySwatch: Colors.blueGrey,
      ),
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
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
