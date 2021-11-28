import 'dart:io';

import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/models/parent_model.dart';
import 'package:adhkar_flutter/ui/home/bloc/home_bloc.dart';
import 'package:adhkar_flutter/ui/home/pages/first_page.dart';
import 'package:adhkar_flutter/ui/home/pages/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/*
 * Home Page
*/
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ParentModel> parentModels = [];
  var _isLoading = false;
  PdfViewerController controller;

  PageController pageController;
  var _currentPage = 1;

  @override
  void initState() {
    /*
      Init controller and pageView Controller
    */
    controller = PdfViewerController();
    pageController = PageController(
      initialPage: _currentPage,
      keepPage: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_currentPage == 0)
          // back to Index page
          pageController.animateToPage(1,
              duration: Duration(milliseconds: 150), curve: Curves.easeIn);
        else
          // close the app
          exit(0);
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(GetData(context: context)),
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is Loading) _isLoading = true;
              if (state is Success) {
                parentModels = state.parentModels;
                pageController.animateToPage(0,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.easeIn);
                Future.delayed(Duration.zero, () {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeIn);
                  _isLoading = false;
                });
              }
              if (state is Failed) {
                _isLoading = false;
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red.withOpacity(0.4),
                    content: Text(state.msg),
                  ),
                );
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  children: [
                    Visibility(
                      visible: !_isLoading,
                      child: SecondPage(
                        controller: controller,
                        backPressed: () {
                          pageController.animateToPage(1,
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeIn);
                        },
                      ),
                    ),
                    _isLoading
                        ? SizedBox.shrink()
                        : FirstPage(
                            parentModels: parentModels,
                            onPressed: (Model model) {
                              setState(() {
                                pageController.animateToPage(
                                  0,
                                  duration: Duration(milliseconds: 150),
                                  curve: Curves.easeIn,
                                );
                                controller.jumpToPage(model.page);
                              });
                            },
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
