import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktailr/src/blocs/ingredient_bloc.dart';
import 'package:cocktailr/src/constants/app_strings.dart';
import 'package:cocktailr/src/enums/image_size.dart';
import 'package:cocktailr/src/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CocktailIngredientListItem extends StatelessWidget {
  final String ingredientName;
  final String measurement;
  final bool isLastIngredient;

  CocktailIngredientListItem({
    @required this.ingredientName,
    @required this.measurement,
    @required this.isLastIngredient,
  });

  @override
  Widget build(BuildContext context) {
    final ingredientBloc = Provider.of<IngredientBloc>(context);

    return StreamBuilder(
      stream: ingredientBloc.ingredients,
      builder: (context, AsyncSnapshot<Map<String, Future<Ingredient>>> snapshot) {
        if (!snapshot.hasData) {
          return ListTile();
        }

        return isLastIngredient
            ? _cocktailIngredientListItem(snapshot.data[ingredientName])
            : _cocktailIngredientListItemWithDivider(snapshot.data[ingredientName]);
      },
    );
  }

  Widget _cocktailIngredientListItemWithDivider(Future<Ingredient> ingredientFuture) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _cocktailIngredientListItem(ingredientFuture),
          Divider(),
        ],
      );

  Widget _cocktailIngredientListItem(Future<Ingredient> ingredientFuture) => FutureBuilder(
        future: ingredientFuture,
        builder: (context, AsyncSnapshot<Ingredient> snapshot) {
          if (!snapshot.hasData) {
            return ListTile();
          }

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: <Widget>[
                _ingredientImage(snapshot.data, context),
                SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ingredientName(),
                    SizedBox(height: 4),
                    _ingredientMeasurement(),
                  ],
                ),
              ],
            ),
          );
        },
      );

  Widget _ingredientImage(Ingredient ingredient, BuildContext context) => FadeInImage(
        image: CachedNetworkImageProvider("${ingredient.image(ImageSize.SMALL)}"),
        fit: BoxFit.contain,
        height: MediaQuery.of(context).size.width / 7.5,
        width: MediaQuery.of(context).size.width / 7.5,
        placeholder: AssetImage(whitePlaceholder),
      );

  Widget _ingredientName() => Text(ingredientName);

  Widget _ingredientMeasurement() => Text(
        measurement,
        style: TextStyle(
          color: Colors.black54,
        ),
      );
}
