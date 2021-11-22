import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/ui/home/widgets/dismiss_widget.dart';
import 'package:adhkar_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildDoaaWidget extends StatefulWidget {
  final Model object;
  final Function onPressedFavorite;
  final int index;
  final Function onPressed;
  final Function onRemovePressed;
  final int listSize;
  final bool isFavorite;

  const BuildDoaaWidget({
    Key key,
    this.object,
    this.onPressedFavorite,
    this.index,
    this.onPressed,
    this.onRemovePressed,
    this.listSize,
    this.isFavorite,
  }) : super(key: key);

  @override
  _BuildDoaaWidgetState createState() => _BuildDoaaWidgetState();
}

class _BuildDoaaWidgetState extends State<BuildDoaaWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed(widget.object);
      },
      child: Container(
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
        child: !widget.isFavorite
            ? ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 11.0, horizontal: 18.0),
                isThreeLine: false,
                title: Text(
                  widget.object.name,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                trailing: SvgPicture.asset(
                  'assets/images/star_yellow.png',
                  color: Color(0xff356e6e),
                  height: 35,
                ),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/images/arrow.svg',
                        color: Color(0xff356e6e).withOpacity(0.4), height: 22),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: DismissibleWidget(
                  item: widget.object,
                  onDismissed: (direction) {
                    widget.onRemovePressed(widget.object);
                  },
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 11.0, horizontal: 18.0),
                    isThreeLine: false,
                    trailing: GestureDetector(
                      onTap: () {
                        widget.onRemovePressed(widget.object);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/star_yellow.png',
                            height: 35,
                          ),
                          Text(
                            '${AppUtils.englishToFarsi(number: (widget.index + 1).toString())}',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      widget.object.name,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                    leading: SvgPicture.asset('assets/images/arrow.svg',
                        color: Color(0xff356e6e).withOpacity(0.4), height: 22),
                  ),
                ),
              ),
      ),
    );
  }
}
