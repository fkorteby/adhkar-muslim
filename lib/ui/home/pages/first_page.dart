import 'package:adhkar_flutter/db/db_helper.dart';
import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/models/parent_model.dart';
import 'package:adhkar_flutter/ui/home/bloc/home_bloc.dart';
import 'package:adhkar_flutter/ui/home/widgets/build_item.dart';
import 'package:adhkar_flutter/ui/home/widgets/favorite_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<Model> favoriteModels = [];
  List<ParentModel> parentModels = [];
  List<GlobalKey> dataListKey = [];
  ScrollController scrollController;
  var _bloc;

  @override
  void initState() {
    initData();
    initController();
    populateListKey();
    super.initState();
  }

  initData() {
    try {
      parentModels = widget.parentModels;
      parentModels.first.isExpand = true;
    } catch (ex) {
      print(ex);
    }
  }

  initController() {
    scrollController =
        ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels < 300) {
          getFavoriteItems();
        }
      }
    });
  }

  void populateListKey() {
    dataListKey = [];
    for (var s in parentModels) {
      dataListKey.add(GlobalKey());
    }
  }

  void getFavoriteItems() {
    Future.delayed(Duration.zero, () async {
      favoriteModels = await DbHelper.instance.getAllFavoritesModels();
      if (mounted) setState(() {});
    });
  }

  void refreshFavoriteItemsList() {
    if (scrollController.position.pixels < 100) {
      getFavoriteItems();
    }
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider<HomeBloc>(
          create: (context) =>
              HomeBloc()..add(GetFavoriteItems(context, parentModels)),
          lazy: false,
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is GetFavoriteItemsSuccess) {
                favoriteModels = state.favoriteItems;
                parentModels = state.parentModel;
              }

              if (state is InsertSuccess) {
                parentModels = state.parentModel;
                refreshFavoriteItemsList();
              }

              if (state is DeleteSuccess) {
                parentModels = state.parentModel;
                refreshFavoriteItemsList();
              }

              if (state is Failed) {
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
                return CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    _buildHeader(),
                    favoriteModels.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          )
                        : SliverToBoxAdapter(
                            child: FavoriteWidget(
                              favoriteModels: favoriteModels.reversed.toList(),
                              onPressed: (model) {
                                widget.onPressed(model);
                              },
                              onDelete: (model) {
                                if (_bloc == null)
                                  _bloc = BlocProvider.of<HomeBloc>(context);
                                _bloc.add(
                                    DeleteItem(context, model, parentModels));
                                favoriteModels.remove(model);
                              },
                            ),
                          ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 12.0,
                      ),
                    ),
                    parentModels.isEmpty || dataListKey.isEmpty
                        ? _buildLoading()
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return BuildItem(
                                  key: dataListKey[index],
                                  object: parentModels[index].models,
                                  parentName: parentModels[index].name,
                                  parentModel: parentModels[index],
                                  index: index,
                                  onPressed: (object) {
                                    widget.onPressed(object);
                                  },
                                  onPressedIndex: (x) =>
                                      onPressedItem(x, index),
                                  onPressedFavorite: (object, b) {
                                    if (_bloc == null)
                                      _bloc =
                                          BlocProvider.of<HomeBloc>(context);
                                    if (!b)
                                      _bloc.add(InsertNewItem(
                                          context, object, parentModels));
                                    else
                                      _bloc.add(DeleteItem(
                                          context, object, parentModels));
                                  },
                                );
                              },
                              childCount: parentModels.length,
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
                    _buildFooter(),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20.0,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

  @override
  bool get wantKeepAlive => true;

  void onPressedItem(x, index) {
    if (_currentIndex == x) {
      setState(() {
        parentModels[_currentIndex].isExpand =
            !parentModels[_currentIndex].isExpand;
      });
      this._currentIndex = x;
      return;
    }
    // if the currentIndex != index
    this._currentIndex = x;
    try {
      ParentModel p = parentModels.firstWhere((element) => element.isExpand);
      setState(() {
        p.isExpand = false;
        parentModels[_currentIndex].isExpand = true;
      });
    } catch (ex) {
      setState(() {
        parentModels[index].isExpand = true;
      });
      print(ex);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Scrollable.ensureVisible(dataListKey[_currentIndex].currentContext));
  }
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

_buildFooter() => SliverToBoxAdapter(
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
                    ..onTap =
                        () => _launchURL('https://www.smartprints-ksa.com/'),
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
    );

_buildLoading() => SliverToBoxAdapter(
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
    );
