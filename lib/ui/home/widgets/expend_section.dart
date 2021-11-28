import 'package:adhkar_flutter/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ExpandedSection extends StatefulWidget {
  final Widget child;
  bool expand;
  final Function onPressed;
  final Function onPressedFavorite;
  final List<Model> object;
  final bool isColored;

  ExpandedSection({
    this.expand = false,
    this.child,
    this.onPressed,
    this.onPressedFavorite,
    this.object,
    this.isColored,
  });

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
      reverseDuration: Duration(milliseconds: 1500),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    print('_runExpandCheck');
    if (widget.expand)
      expandController.forward();
    else
      expandController.reverse();
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: animation,
      child: Container(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.object.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                widget.onPressed(widget.object[index]);
              },
              child: Container(
                margin: EdgeInsets.only(top: 18.0),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      isThreeLine: false,
                      title: Text(
                        widget.object[index].name,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color:
                                widget.isColored ? Colors.white : Colors.black,
                            fontSize: 14.0),
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset('assets/images/arrow.svg',
                              color: widget.isColored
                                  ? Colors.white
                                  : Color(0xff356e6e),
                              height: 22),
                          const SizedBox(
                            width: 8.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onPressedFavorite(widget.object[index],
                                  widget.object[index].isFavorite);
                              widget.object[index].isFavorite =
                                  !widget.object[index].isFavorite;
                            },
                            child: !widget.object[index].isFavorite
                                ? widget.isColored
                                    ? Image.asset(
                                        'assets/images/star_white.png',
                                        height: 20.0,
                                      )
                                    : Image.asset(
                                        'assets/images/star_gray.png',
                                        height: 20.0,
                                      )
                                : Image.asset(
                                    'assets/images/star_yellow.png',
                                    height: 20.0,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0.3,
                      color: widget.isColored
                          ? Colors.white.withOpacity(0.5)
                          : Color(0xff356e6e).withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
