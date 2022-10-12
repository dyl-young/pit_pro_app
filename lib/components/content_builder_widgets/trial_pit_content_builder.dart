import 'dart:math';

//packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//local imports
import '../../hive_components/add_edit_delete_functions.dart';
import '../../models/trial_pit.dart';
import '../../pages/trial_pit_details_page.dart';
import '../widgets/confirm_alert_dialog.dart';

//!list view builder
Widget trialPitListViewBuilder(BuildContext context, List<TrialPit> trialPits) {
  if (trialPits.isEmpty) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Center(child: SizedBox(height: 100)),
        Text('No Trial Pits Found',
            style: TextStyle(color: Colors.grey, fontSize: 20)),
      ],
    );
  } else {
    return Scrollbar(
      child: ListView(
        children: [
          ...trialPits.map(
            (e) => Padding(
              padding: const EdgeInsets.fromLTRB(10,4,10,4),
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
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: Icon(Icons.calendar_view_day),
                      child: Transform.rotate(angle: pi, child: const Icon(Icons.line_style_outlined, size: 30)),
    
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
      ),
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
                    (pitNumber, coords, elevation, wt, layersList, contractor, machine, imagePath, notes) =>
                        editTrialPit(trialPit, pitNumber, coords,
                            elevation, wt, layersList, contractor, machine, imagePath, notes),
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
