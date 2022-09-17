import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pit_pro_app/components/confirm_alert_dialog.dart';
import 'package:pit_pro_app/pages/layer_form_page.dart';

import '../hive_components/add_edit_delete_functions.dart';
import '../models/layer.dart';
import '../models/trial_pit.dart';
import '../pages/trial_pit_details_page.dart';

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
            const Icon(Icons.add),
            Text(title),
          ],
        ),

        //?Navigator?
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrialPitDetailsPage(
                  onClickedDone:
                      (pitNumber, wt, pwt, coords, elevation, layersList) =>
                          addTrialPit(trialPits, wt, pwt, pitNumber, coords,
                              elevation, layersList),
                ),
              ),
            )),
  );
}

//! Add Borehole/aguer buttons(if implemented, split up buttons)
Widget addOtherButtons(String title) {
  return SizedBox(
    width: 117,
    height: 40,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add),
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
    width: 117,
    height: 40,
    child: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            Text(title),
          ],
        ),

        //?Navigator?
        //TODO:  Navigate to layer form page
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LayerFormPage(
                  onClickedDone: (
                    depth,
                    moisture,
                    colour,
                    consistency,
                    structure,
                    soilTypes,
                    origin,
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
                    consistency,
                    structure,
                    soilTypes,
                    origin,
                    // wt,
                    // pwt,
                    pm,
                    notes,
                  ),
                ),
              ),
            )),
  );
}
