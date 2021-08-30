import 'dart:math';

import 'package:flutter/material.dart';

class LazyScrollController extends ChangeNotifier {
  bool _shouldLoadNextPage = false;
  void loadNextPage() {
    _shouldLoadNextPage = true;
    this.notifyListeners();
  }
}

class LazyScrollableListView<T> extends StatefulWidget {
  final int pageSize;
  final List<T> items;
  final bool autoLoad;
  final Widget Function(BuildContext, T) builder;
  final LazyScrollController? controller;
  
  const LazyScrollableListView({
    Key? key,
    required this.pageSize,
    required this.items,
    required this.builder,
    this.autoLoad = true,
    this.controller,
  }) : super(key: key);

  @override
  _LazyScrollableListViewState<T> createState() =>
      _LazyScrollableListViewState<T>();
}

class _LazyScrollableListViewState<T> extends State<LazyScrollableListView<T>> {
  late int _currentPage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    widget.controller?.addListener(() {
      if (widget.controller!._shouldLoadNextPage) {
        widget.controller!._shouldLoadNextPage = false;
        _loadNewItems();
      }
    });
  }

  void _loadNewItems() {
    if (!isLoading) {
      isLoading = true;
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _currentPage++;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: min(widget.items.length, _currentPage * widget.pageSize + 1),
        itemBuilder: (context, index) {
          var itemCount =
              min(widget.items.length, _currentPage * widget.pageSize);
          if (itemCount == index) {
            _loadNewItems();
            return CircularProgressIndicator();
          }
          return widget.builder.call(context, widget.items[index]);
        });
  }
}
