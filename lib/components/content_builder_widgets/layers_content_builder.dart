import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_pro_app/hive_components/add_edit_delete_functions.dart';

import '../../models/layer.dart';
import '../../pages/layer_form_page.dart';
import '../confirm_alert_dialog.dart';

//!list view builder
Widget layerListViewBuilder(BuildContext context, List<Layer> layers) {
  if (layers.isEmpty) {
    return const SizedBox(
        height: 250,
        child: Center(
            child: Text('No Layers Found',
                style: TextStyle(color: Colors.grey, fontSize: 20))));
  } else {
    return ListView(
      children: [
        ...layers.map(
          (e) => Padding(
            padding: const EdgeInsets.all(4.0),
            child:  Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 219, 219, 219),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(

                  //*leading icon
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.layers_rounded)

                  ),

                  //*date
                  title: Text(
                    DateFormat.yMd().format(e.createdDate),
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  //*Hole number heaidng
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Layer: ${layers.lastIndexOf(e) + 1}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text('layer Depth: ${e.depth} m')
                      ],
                    ),
                  ),

                  children: [
                    buildLayerButtons(context, layers, e),
                  ],
                ),
              ),
            ),

          ),
        )
      ],
    );
  }
}

//! Expansion tile buttons
Widget buildLayerButtons(BuildContext context, List<Layer> layers, Layer layer) {
  const color = Color.fromARGB(255, 9, 138, 13);

  return Row(
    children: [
      //*edit button
      Expanded(
        child: TextButton.icon(
          label: const Text('Edit', style: TextStyle(color: color)),
          icon: const Icon(Icons.edit, color: color),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LayerFormPage(
                layer: layer,
                onClickedDone: (depth, moisture, colour, consistency, structure, soilTypes, origin, originType, pm, notes) 
                => editLayer(layer, depth, moisture, colour, consistency, structure, soilTypes, origin, originType, pm, notes),
              ),
            ),
          ),
        ),
      ),

       //*delete button
      Expanded(
        child: TextButton.icon(
          label: const Text('Delete', style: TextStyle(color: color)),
          icon: const Icon(Icons.delete, color: color),
          onPressed: () => showDialog(
            context: context,
            builder: (context) =>
                confirmDelete(context, layers, layer, deleteLayer),
          ),
        ),
      )
      
    ],
  );
}
