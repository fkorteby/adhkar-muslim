import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

import 'build_item_doaa.dart';

class FavoriteWidget extends StatelessWidget {
  final List<Model> favoriteModels;
  final Function onPressed;
  final Function onDelete;
  const FavoriteWidget(
      {Key key, this.favoriteModels, this.onPressed, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        favoriteModels.isEmpty
            ? SizedBox.shrink()
            : Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    '${AppUtils.englishToFarsi(number: 'المُفَضّلَة')}',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
        favoriteModels.isEmpty
            ? SizedBox.shrink()
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: favoriteModels == null ||
                        favoriteModels.length == null ||
                        favoriteModels.length == 0
                    ? 0
                    : favoriteModels.length,
                itemBuilder: (context, index) {
                  return BuildDoaaWidget(
                    isFavorite: true,
                    onRemovePressed: (model) {
                      onDelete(model);
                    },
                    listSize: favoriteModels.length,
                    object: favoriteModels[index],
                    index: index,
                    onPressed: (object) {
                      onPressed(object);
                    },
                  );
                },
              ),
        favoriteModels.isEmpty
            ? SizedBox.shrink()
            : Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    '${AppUtils.englishToFarsi(number: 'الفَهرَس')}',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
      ],
    );
  }
}
