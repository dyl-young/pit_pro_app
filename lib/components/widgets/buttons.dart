import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pit_pro_app/components/widgets/confirm_alert_dialog.dart';
import 'package:pit_pro_app/pages/layer_form_page.dart';

import '../../hive_components/add_edit_delete_functions.dart';
import '../../models/layer.dart';
import '../../models/trial_pit.dart';
import '../../pages/trial_pit_details_page.dart';

//! Cancel button
Widget cancelButton(
    BuildContext context, List<HiveObject> objList, bool isNotEditing) {
  if (isNotEditing) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      child: Row(
        children: const [
          Text('Cancel '),
          Icon(Icons.cancel_outlined, size: 20),
        ],
      ), //const ,

      onPressed: () => showDialog(
        context: context,
        builder: (context) => confirmCancel(context, objList),
      ),
      // onPressed: () {
      //   print('testing 1');
      //   confirmCancel(context, objList);
      // },
    );
  } else {
    //no cancel option when editing created jobs
    return const SizedBox.shrink();
  }
}

//! Add Trial Pit Button
Widget addTrialPittButton(
    BuildContext context, List<TrialPit> trialPits, String title) {
  return SizedBox(
    width: 117,
    height: 40,
    child: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Icon(Icons.calendar_view_day),
            Transform.rotate(
                angle: pi, child: const Icon(Icons.line_style_outlined)),
            Text(' $title'),
          ],
        ),

        //?Navigator?
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrialPitDetailsPage(
                  onClickedDone: (
                    pitNumber,
                    coords,
                    elevation,
                    wt,
                    layersList,
                    contractor,
                    machine,
                    imagePath,
                    notes,
                  ) =>
                      addTrialPit(
                    trialPits,
                    pitNumber,
                    coords,
                    elevation,
                    wt,
                    layersList,
                    contractor,
                    machine,
                    imagePath,
                    notes,
                  ),
                ),
              ),
            )),
  );
}

//! Add Borehole button (if implemented)
Widget addBoreholeButtons(String title) {
  return SizedBox(
    width: 117,
    height: 40,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
              angle: 0.5 * pi,
              child: const Icon(
                Icons.calendar_view_day,
              )),
          Text(title),
        ],
      ),
      onPressed: () {},
    ),
  );
}

//! Add aguer button
Widget addAugerButtons(String title) {
  return SizedBox(
    width: 117,
    height: 40,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tornado),
          Text(title),
        ],
      ),
      onPressed: () {},
    ),
  );
}

//! Add Layer Button
Widget addLayerPittButton(
    BuildContext context, List<Layer> layers, String title) {
  return SizedBox(
    width: 140,
    height: 40,
    child: ElevatedButton(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.layers_rounded),
          Text(' $title'),
        ],
      ),

      //?Navigator?
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LayerFormPage(
            onClickedDone: (
              depth,
              moisture,
              colour,
              colourPattern,
              consistency,
              structure,
              soilTypes,
              origin,
              originType,
              // wt,
              // pwt,
              pm,
              notes,
            ) =>
                addLayer(
              layers,
              depth,
              moisture,
              colour,
              colourPattern,
              consistency,
              structure,
              soilTypes,
              origin,
              originType,
              // wt,
              // pwt,
              pm,
              notes,
            ),
          ),
        ),
      ),
    ),
  );
}
