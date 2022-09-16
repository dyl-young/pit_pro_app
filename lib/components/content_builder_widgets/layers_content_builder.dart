import 'package:flutter/material.dart';

import '../../models/layer.dart';

Widget buildLayersContent(List<Layer> layers) {
  if (layers.isEmpty) {
    return const SizedBox(
        height: 400,
        child: Center(
            child: Text('No Layers Found',
                style: TextStyle(color: Colors.grey, fontSize: 20))));
  } else {
    return SizedBox(
      height: 400,
      child: Column(
        children: const [
          // ValueListenableBuilder<Box<Layer>>(
          //   valueListenable: Boxes.geTrialPits().listenable(),
          //   builder: (context, box, _) {
          //     return layerListViewBuilder(context, layers);
          //   },
          // ),
        ],
      ),
    );
  }
}

//!list view builder
Widget layerListViewBuilder(BuildContext context, List<Layer> layers) {
  if (layers.isEmpty) {
    return const SizedBox(
        height: 250,
        child: Center(
            child: Text('No Layers Found',
                style: TextStyle(color: Colors.grey, fontSize: 20))));
  } else {
    //TODO: implement layers list veiw builder
    return ListView();
  }
}

//! Expansion tile buttons
//TODO: implement layers expansion buttons
Widget buildLayerButtons() {
  return Row();
}
