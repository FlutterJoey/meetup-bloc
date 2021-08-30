import 'package:flutter/material.dart';

class AppPresentation extends StatelessWidget {
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
                    child: explanation,
                  ),
                ),
                if (app != null) ...[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        height: 40 * 16,
                        width: 40 * 9,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black87,
                        ),
                        child: app,
                      ),
                    ),
                  ),
                ],
                if (image != null) ...[
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: image,
                    ),
                  )
                ]
              ],
            ),
          ),
          if (onPrevious != null) ...[
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              child: Material(
                child: IconButton(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.skip_previous_outlined),
                  onPressed: onPrevious,
                ),
              ),
            )
          ],
          if (onNext != null) ...[
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Material(
                child: IconButton(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.skip_next_outlined),
                  onPressed: onNext,
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}
