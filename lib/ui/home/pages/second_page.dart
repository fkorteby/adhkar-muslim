import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/*
  * Second page to display the pdf
*/

class SecondPage extends StatefulWidget {
  final Function backPressed;
  final PdfViewerController controller;

  const SecondPage({Key key, this.backPressed, this.controller})
      : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff356e6e),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'الرّجُوع إلَى الفَهرَس',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Transform.rotate(
              angle: pi,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: widget.backPressed,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SfPdfViewer.asset(
        'assets/adhkar.pdf',
        controller: widget.controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
