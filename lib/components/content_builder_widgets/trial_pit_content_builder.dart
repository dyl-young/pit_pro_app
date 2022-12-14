// *libraries
import 'dart:math';

// *packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// *local imports
import '../../hive_components/add_edit_delete_functions.dart';
import '../../models/trial_pit.dart';
import '../../pages/trial_pit_details_page.dart';
import '../widgets/confirm_alert_dialog.dart';
import '../widgets/page_transition.dart';

//! Trial Pit list view builder
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
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
    
                    //*leading icon
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          Text('Hole No: ${e.pitNumber}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Text('no of layers: ${e.layersList.length}')
                        ],
                      ),
                    ),
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

//! expansion tile buttons
Widget buildTrialPitButtons(BuildContext context, List<TrialPit> trialPits, TrialPit trialPit) {
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
            builder: (context) =>
                confirmObjectDelete(context, trialPits, trialPit, deleteTrialPit),
          ),
        ),
      ),
       //*edit button
      Expanded(
        child: TextButton.icon(
          label: const Text('Edit', style: TextStyle(color: color)),
          icon: const Icon(Icons.edit, color: color),
          onPressed: () => Navigator.of(context).push(
            createRoute(
               TrialPitDetailsPage(
                trialPit: trialPit,
                onClickedDone:
                    (pitNumber, 
                    coords, 
                    elevation,
                    wt,
                    pm, 
                    layersList, 
                    contractor, 
                    machine, 
                    imagePath, 
                    notes) => editTrialPit(
                    trialPit, 
                    pitNumber, 
                    coords,
                    elevation, 
                    wt, 
                    pm, 
                    layersList, 
                    contractor, 
                    machine, 
                    imagePath, 
                    notes),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
