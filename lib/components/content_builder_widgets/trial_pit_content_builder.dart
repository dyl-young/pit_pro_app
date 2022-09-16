import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../hive_components/add_edit_delete_functions.dart';
import '../../models/trial_pit.dart';
import '../../pages/trial_pit_details_page.dart';
import '../confirm_alert_dialog.dart';

//!list view builder
Widget trialPitListViewBuilder(BuildContext context, List<TrialPit> trialPits) {
  if (trialPits.isEmpty) {
    return const SizedBox(
        height: 200,
        child: Center(
            child: Text('No Activities Found',
                style: TextStyle(color: Colors.grey, fontSize: 20))));
  } else {
    return ListView(
      children: [
        ...trialPits.map(
          (e) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 219, 219, 219),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  // tilePadding: const EdgeInsets.all(1),

                  //*leading icon
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.calendar_view_day),
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
                          'Hole No: ${e.pitNumber}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text('no of layers: ${e.layersList.length}')
                      ],
                    ),
                  ),
                  //!Pit index in list of pits -> use this for the layers tile cards
                  // title: Text('Trial Pit: ${trialPits.lastIndexOf(e) + 1}'),

                  children: [
                    buildTrialPitButtons(context, trialPits, e),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//! Expansion tile buttons
Widget buildTrialPitButtons(
    BuildContext context, List<TrialPit> trialPits, TrialPit trialPit) {
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
              builder: (context) => TrialPitDetailsPage(
                trialPit: trialPit,
                onClickedDone:
                    (pitNumber, wt, pwt, coords, elevation, layersList) =>
                        editTrialPit(trialPit, wt, pwt, pitNumber, coords,
                            elevation, layersList),
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
                confirmDelete(context, trialPits, trialPit, deleteTrialPit),
          ),
        ),
      )
    ],
  );
}
