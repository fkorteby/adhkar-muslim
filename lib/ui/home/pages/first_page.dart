import 'package:adhkar_flutter/db/db_helper.dart';
import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/models/parent_model.dart';
import 'package:adhkar_flutter/ui/home/widgets/build_item.dart';
import 'package:adhkar_flutter/ui/home/widgets/build_item_doaa.dart';
import 'package:adhkar_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

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
  List<GlobalKey> dataListKey = [];
  bool isFirstTime = false;

  @override
  void initState() {
    dbHelper = DbHelper();
    Future.delayed(Duration.zero, () async {
      favoriteModels = await dbHelper.getAllModels();
      refreshList();
    });
    super.initState();
  }

  insertModel(Model model) async {
    if (model.id == null) {
      await dbHelper.save(model);
      await refreshList();
    }
  }

  deleteModel(Model model) async {
    await dbHelper.delete(model.id);
    await refreshList();
  }

  List<ParentModel> newParentModels = [];
  List<Model> newModels = [];

  refreshList() async {
    newModels = [];
    favoriteModels = [];
    newParentModels = [];
    var isExist = false;
    favoriteModels = await dbHelper.getAllModels();
    if (favoriteModels.isNotEmpty) {
      for (ParentModel pModel in widget.parentModels) {
        for (Model model in pModel.models) {
          isExist = false;
          for (Model fModel in favoriteModels) {
            if (model.name == fModel.name && model.page == fModel.page) {
              isExist = true;
              model.isFavorite = true;
              model.id = fModel.id;
              break;
            }
          }
          if (isExist) {
            newModels.add(model);
          } else {
            model.isFavorite = false;
            model.id = null;
            newModels.add(model);
          }
        }
        ParentModel pM =
            ParentModel(models: newModels, name: pModel.name, id: pModel.id);
        newParentModels.add(pM);
        newModels = [];
      }
    } else {
      newParentModels = [];
      for (ParentModel pModel in widget.parentModels) {
        for (Model model in pModel.models) {
          model.id = null;
          model.isFavorite = false;
          newModels.add(model);
        }
        ParentModel pM =
            ParentModel(models: newModels, name: pModel.name, id: pModel.id);
        newParentModels.add(pM);
        newModels = [];
      }
    }

    if (mounted) setState(() {});
    if (!isFirstTime) {
      dataListKey = [];
      for (var s in newParentModels) {
        dataListKey.add(GlobalKey());
      }
      isFirstTime = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff356e6e),
            flexibleSpace: FlexibleSpaceBar(
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
                            fontSize: 24,
                            fontFamily: 'NotoKufiArabic',
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '\nمِن صَحِيح البُخَارِي وَ مُسلِم',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'NotoKufiArabic',
                              ),
                            )
                          ]),
                    ),
                  ),
                  // Text(
                  //   'أَذكَار المُسلِم\nمِن صَحِيح البُخَارِي وَ مُسلِم',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
              ),
              background: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/images/sdsd.jpg',
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 12.0),
          ),
          favoriteModels.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                )
              : SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${AppUtils.englishToFarsi(number: 'المُفَضّلَة')}',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
          favoriteModels.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BuildDoaaWidget(
                        isFavorite: true,
                        onRemovePressed: (model) {
                          deleteModel(model);
                        },
                        listSize: favoriteModels.length,
                        object: favoriteModels[index],
                        index: index,
                        onPressed: (object) {
                          widget.onPressed(object);
                        },
                      );
                    },
                    childCount: favoriteModels == null ||
                            favoriteModels.length == null ||
                            favoriteModels.length == 0
                        ? 0
                        : favoriteModels.length,
                  ),
                ),
          favoriteModels.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                )
              : SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${AppUtils.englishToFarsi(number: 'الفَهرَس')}',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
          newParentModels.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
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
                        isVisible: index == _currentIndex ? true : false,
                        listSize: newParentModels.length,
                        object: newParentModels[index].models,
                        parentName: newParentModels[index].name,
                        index: index,
                        onPressed: (object) {
                          widget.onPressed(object);
                        },
                        onPressedIndex: (x) {
                          this._currentIndex = x;
                          // Scrollable.ensureVisible(
                          //     dataListKey[_currentIndex].currentContext);
                          setState(() {
                            WidgetsBinding.instance.addPostFrameCallback((_) =>
                                Scrollable.ensureVisible(
                                    dataListKey[_currentIndex].currentContext));
                          });
                        },
                        onPressedFavorite: (object, b) {
                          if (!b)
                            insertModel(object);
                          else
                            deleteModel(object);
                        },
                      );
                    },
                    childCount: newParentModels.length,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: false,
                    addSemanticIndexes: false,
                  ),
                ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120.0,
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: Padding(
          //       padding: EdgeInsets.only(top: 8.0),
          //       child: Text(
          //         '${AppUtils.englishToFarsi(number: '( ۲ ) الدعاء')}',
          //         textAlign: TextAlign.center,
          //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          //       ),
          //     ),
          //   ),
          // ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       return BuildDoaaWidget(
          //         isFavorite: false,
          //         onPressedFavorite: (object, b) {
          //           if (!b)
          //             insertModel(object);
          //           else
          //             deleteModel(object);
          //         },
          //         onRemovePressed: () {},
          //         listSize: widget.doaa.length,
          //         object: widget.doaa[index],
          //         index: index,
          //         onPressed: (object) {
          //           widget.onPressed(object);
          //         },
          //       );
          //     },
          //     childCount: widget.doaa.length,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
