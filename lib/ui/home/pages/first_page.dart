import 'package:adhkar_flutter/db/db_helper.dart';
import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/models/parent_model.dart';
import 'package:adhkar_flutter/ui/home/widgets/build_item.dart';
import 'package:adhkar_flutter/ui/home/widgets/favorite_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstPage extends StatefulWidget {
  final List<ParentModel> parentModels;
  final Function onPressed;

  const FirstPage({Key key, this.parentModels, this.onPressed})
      : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with AutomaticKeepAliveClientMixin {
  var _currentIndex = 0;
  DbHelper dbHelper;
  List<Model> favoriteModels = [];
  List<Model> cachedModels = [];
  List<GlobalKey> dataListKey = [];
  bool isFirstTime = false;
  ScrollController scrollController;

  @override
  void initState() {
    try {
      widget.parentModels.first.isExpand = true;
    } catch (ex) {
      print(ex);
    }
    dbHelper = DbHelper();
    scrollController =
        ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels < 300) {
          setState(() {
            favoriteModels = [];
            favoriteModels.addAll(cachedModels);
          });
        }
      }
    });
    Future.delayed(Duration.zero, () async {
      favoriteModels = await dbHelper.getAllFavoritesModels();
      await refreshList();
    });
    super.initState();
  }

  insertModel(Model model) async {
    if (model.id == null) {
      await dbHelper.save(model);
      await refreshList();
      if (scrollController.position.pixels < 100) {
        setState(() {
          favoriteModels = [];
          favoriteModels.addAll(cachedModels);
        });
      }
    }
  }

  deleteModel(Model model) async {
    await dbHelper.delete(model.id);
    await refreshList();
    if (scrollController.position.pixels < 100) {
      setState(() {
        favoriteModels = [];
        favoriteModels.addAll(cachedModels);
      });
    }
  }

  refreshList() async {
    cachedModels = [];
    var isExist = false;
    cachedModels = await dbHelper.getAllFavoritesModels();
    if (cachedModels.isNotEmpty) {
      for (ParentModel pModel in widget.parentModels) {
        for (Model model in pModel.models) {
          isExist = false;
          for (Model fModel in cachedModels) {
            if (model.name == fModel.name && model.page == fModel.page) {
              isExist = true;
              model.isFavorite = true;
              model.id = fModel.id;
              break;
            }
          }
          if (!isExist) {
            model.isFavorite = false;
            model.id = null;
          }
        }
      }
    } else {
      for (ParentModel pModel in widget.parentModels) {
        for (Model model in pModel.models) {
          model.id = null;
          model.isFavorite = false;
        }
      }
    }

    if (!isFirstTime) {
      dataListKey = [];
      for (var s in widget.parentModels) {
        dataListKey.add(GlobalKey());
      }
      isFirstTime = true;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: FavoriteWidget(
              favoriteModels: favoriteModels.reversed.toList(),
              onPressed: (model) {
                widget.onPressed(model);
              },
              onDelete: (model) {
                deleteModel(model);
                favoriteModels.remove(model);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 12.0,
            ),
          ),
          widget.parentModels.isEmpty || dataListKey.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BuildItem(
                        key: dataListKey[index],
                        listSize: widget.parentModels.length,
                        object: widget.parentModels[index].models,
                        parentName: widget.parentModels[index].name,
                        parentModel: widget.parentModels[index],
                        index: index,
                        currentIndex: _currentIndex,
                        onPressed: (object) {
                          widget.onPressed(object);
                        },
                        onPressedIndex: (x) {
                          print(x);
                          print(_currentIndex);
                          if (_currentIndex == x) {
                            setState(() {
                              widget.parentModels[_currentIndex].isExpand =
                                  !widget.parentModels[_currentIndex].isExpand;
                            });
                            this._currentIndex = x;
                            return;
                          }
                          this._currentIndex = x;

                          try {
                            ParentModel p = widget.parentModels
                                .firstWhere((element) => element.isExpand);
                            setState(() {
                              p.isExpand = false;
                              widget.parentModels[_currentIndex].isExpand =
                                  true;
                            });
                          } catch (ex) {
                            setState(() {
                              widget.parentModels[index].isExpand = true;
                            });
                            print(ex);
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) =>
                              Scrollable.ensureVisible(
                                  dataListKey[_currentIndex].currentContext));
                        },
                        onPressedFavorite: (object, b) {
                          if (!b)
                            insertModel(object);
                          else
                            deleteModel(object);
                        },
                      );
                    },
                    childCount: widget.parentModels.length,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                    addSemanticIndexes: true,
                  ),
                ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20.0,
            ),
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "برمجة وإعداد",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'NotoKufiArabic',
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' البصمات الذكية',
                        style: TextStyle(
                          color: Color(0xff356e6e),
                          fontSize: 14,
                          fontFamily: 'NotoKufiArabic',
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              _launchURL('https://www.smartprints-ksa.com/'),
                      ),
                      TextSpan(
                        text: ' لتقنية المعلومات',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'NotoKufiArabic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}

_buildHeader() => SliverAppBar(
      expandedHeight: 170,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xff356e6e),
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var top = constraints.biggest.height;
        return FlexibleSpaceBar(
          centerTitle: true,
          title: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "أَذكَار المُسلِم",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: top < 100 ? 16 : 24,
                        fontFamily: 'NotoKufiArabic',
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: top < 100
                              ? ' مِن صَحِيح البُخَارِي وَ مُسلِم'
                              : '\nمِن صَحِيح البُخَارِي وَ مُسلِم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: top < 100 ? 16 : 12,
                            fontFamily: 'NotoKufiArabic',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
          background: Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/images/background.jpg',
            ),
          ),
        );
      }),
    );
