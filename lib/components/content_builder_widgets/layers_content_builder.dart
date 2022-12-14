//* packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// *local imports
import '../../hive_components/add_edit_delete_functions.dart';
import '../../models/layer.dart';
import '../../pages/layer_form_page.dart';
import '../widgets/confirm_alert_dialog.dart';
import '../widgets/page_transition.dart';

//!list view builder
Widget layerListViewBuilder(BuildContext context, List<Layer> layers) {
  if (layers.isEmpty) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 50),
            Text('No Layers Found', style: TextStyle(color: Colors.grey, fontSize: 20)),
          ],
        )
      ),
    );
  } else {
    return Scrollbar(
      child: ListView(
        children: [
          ...layers.map(
            (e) => Padding(
              padding: const EdgeInsets.fromLTRB(10,4,10,4),
              child:  Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(255, 219, 219, 219),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    //*leading icon
                    leading: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.layers_rounded, size: 30)
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
                          Text('Layer: ${layers.lastIndexOf(e) + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Text('layer Depth: ${e.depth} m')
                        ],
                      ),
                    ),

                    //* buttons
                    children: [buildLayerButtons(context, layers, e)],
                  ),
                ),
              ),
      
            ),
          )
        ],
      ),
    );
  }
}

//! expansion tile buttons
Widget buildLayerButtons(BuildContext context, List<Layer> layers, Layer layer) {
  const color = Color.fromARGB(255, 9, 138, 13);

  return Row(
    children: [
       //*delete button
      Expanded(
        child: TextButton.icon(
          label: const Text('Delete', style: TextStyle(color: color)),
          icon: const Icon(Icons.delete, color: color),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => confirmObjectDelete(context, layers, layer, deleteLayer),
          ),
        ),
      ),

      //*edit button
      Expanded(
        child: TextButton.icon(
          label: const Text('Edit', style: TextStyle(color: color)),
          icon: const Icon(Icons.edit, color: color),
          onPressed: () =>  Navigator.of(context).push(
            createRoute( LayerFormPage(
                layer: layer,
                onClickedDone: (depth, moisture, colour, otherColour, colourPattern, consistency, structure, soilTypes, origin, originType, pm, notes) 
                => editLayer(layer, depth, moisture, colour, otherColour, colourPattern, consistency, structure, soilTypes, origin, originType, pm, notes),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
