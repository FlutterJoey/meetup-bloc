import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppPresentation extends StatefulWidget {
  final Widget? app;
  final Widget? image;
  final Widget explanation;
  final void Function()? onNext;
  final void Function()? onPrevious;
  const AppPresentation(
      {Key? key,
      this.app,
      this.image,
      required this.explanation,
      this.onNext,
      this.onPrevious})
      : super(key: key);

  @override
  _AppPresentationState createState() => _AppPresentationState();
}

class _AppPresentationState extends State<AppPresentation> {
  @override
  void initState() {
    super.initState();
    var store = FirebaseFirestore.instance;
    store
        .collection('presentations')
        .doc('meetup-bloc')
        .snapshots()
        .listen((event) {
      if (event.exists && mounted) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: widget.explanation,
                  ),
                ),
                if (widget.app != null) ...[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        height: 60 * 16,
                        width: 60 * 9,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black87,
                        ),
                        child: widget.app,
                      ),
                    ),
                  ),
                ],
                if (widget.image != null) ...[
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: widget.image,
                    ),
                  )
                ]
              ],
            ),
          ),
          if (widget.onPrevious != null) ...[
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              child: Material(
                child: IconButton(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.skip_previous_outlined),
                  onPressed: widget.onPrevious,
                ),
              ),
            )
          ],
          if (widget.onNext != null) ...[
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Material(
                child: IconButton(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.skip_next_outlined),
                  onPressed: widget.onNext,
                ),
              ),
            )
          ],
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(50),
            child: Image.asset('assets/images/watermark.png'),
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('presentations')
                .doc('meetup-bloc')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                var data = snapshot.data!.data();
                var questions = data?['questions'] as List<dynamic>?;
                var currentQuestion =
                    questions?.isNotEmpty == true ? questions?.first : null;
                if (currentQuestion != null) {
                  return Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.orangeAccent,
                                blurRadius: 100,
                                spreadRadius: -2)
                          ]),
                      child: Icon(Icons.question_answer, size: 75),
                    ),
                  );
                }
              }
              return SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
