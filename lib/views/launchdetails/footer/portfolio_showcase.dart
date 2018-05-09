import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';

class PortfolioShowcase extends StatelessWidget {

  PortfolioShowcase(this.launch);

  final Launch launch;

  List<Widget> _buildItems() {
    var items = <Widget>[];

    for (var i = 1; i <= 6; i++) {
      var image = new Image.network(
        launch.rocket.imageURL,
        width: 200.0,
        height: 200.0,
      );

      items.add(image);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );

    return new GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: _buildItems(),
    );
  }
}
