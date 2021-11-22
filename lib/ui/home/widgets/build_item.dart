import 'dart:math';

import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'expend_section.dart';

class BuildItem extends StatefulWidget {
  final List<Model> object;
  final String parentName;
  final String assetPdf;
  final int index;
  final Function onPressed;
  final Function onPressedIndex;
  final Function onPressedFavorite;
  final int listSize;
  final bool isVisible;

  BuildItem({
    Key key,
    this.object,
    this.parentName,
    this.assetPdf,
    this.index,
    this.onPressed,
    this.onPressedIndex,
    this.onPressedFavorite,
    this.listSize,
    this.isVisible,
  }) : super(key: key);

  @override
  _BuildItemState createState() => _BuildItemState();
}

class _BuildItemState extends State<BuildItem> {
  bool _isVisibleIcon = false;

  @override
  void initState() {
    _isVisibleIcon = widget.isVisible;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 18.0),
          margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 22.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 1,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListTile(
                  isThreeLine: false,
                  contentPadding: EdgeInsets.all(0.0),
                  onTap: () {
                    _isVisibleIcon = !_isVisibleIcon;
                    widget.onPressedIndex(widget.index);
                  },
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/star.svg',
                        color: Color(0xff356e6e),
                        height: 35,
                      ),
                      Text(
                        '${AppUtils.englishToFarsi(number: (widget.index + 1).toString())}',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  title: Text(
                    widget.parentName,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                  leading: Transform.rotate(
                    angle: _isVisibleIcon ? pi : 0,
                    child: SvgPicture.asset('assets/images/arrow_down.svg',
                        color: Color(0xff356e6e), height: 12),
                  ),
                ),
              ),
              SizedBox(height: 0.0),
              Visibility(
                visible: _isVisibleIcon,
                child: ExpandedSection(
                  expand: _isVisibleIcon,
                  object: widget.object,
                  path: widget.assetPdf,
                  onPressed: (v) {
                    widget.onPressed(v);
                  },
                  onPressedFavorite: (object, b) {
                    widget.onPressedFavorite(object, b);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
