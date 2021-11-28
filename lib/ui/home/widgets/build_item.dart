import 'dart:math';

import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/models/parent_model.dart';
import 'package:adhkar_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'expend_section.dart';

class BuildItem extends StatefulWidget {
  final List<Model> object;
  final String parentName;
  final int index;
  final Function onPressed;
  final Function onPressedIndex;
  final Function onPressedFavorite;
  final ParentModel parentModel;

  BuildItem(
      {Key key,
      this.object,
      this.parentName,
      this.index,
      this.onPressed,
      this.onPressedIndex,
      this.onPressedFavorite,
      this.parentModel})
      : super(key: key);

  @override
  _BuildItemState createState() => _BuildItemState();
}

class _BuildItemState extends State<BuildItem> {
  bool _isVisibleIcon = false;

  @override
  void initState() {
    _isVisibleIcon = widget.parentModel.isExpand;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 18.0),
          margin: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: widget.index == 0 || widget.index == 16
                ? Color(0xff356e6e).withOpacity(1)
                : Colors.white,
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
                        color: widget.index == 0 || widget.index == 16
                            ? Colors.white
                            : Color(0xff356e6e),
                        height: 35,
                      ),
                      Text(
                        '${AppUtils.englishToFarsi(number: (widget.index + 1).toString())}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: widget.index == 0 || widget.index == 16
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    widget.parentName,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: widget.index == 0 || widget.index == 16
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                  leading: Transform.rotate(
                    angle: _isVisibleIcon ? pi : 0,
                    child: SvgPicture.asset('assets/images/arrow_down.svg',
                        color: widget.index == 0 || widget.index == 16
                            ? Colors.white
                            : Color(0xff356e6e),
                        height: 12),
                  ),
                ),
              ),
              SizedBox(height: 0.0),
              Visibility(
                visible: widget.parentModel.isExpand,
                child: ExpandedSection(
                  isColored:
                      widget.index == 0 || widget.index == 16 ? true : false,
                  expand: widget.parentModel.isExpand,
                  object: widget.object,
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
