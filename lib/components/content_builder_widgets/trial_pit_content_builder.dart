import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../hive_components/add_edit_delete_functions.dart';
import '../../models/trial_pit.dart';
import '../../pages/Trial_pit_details_page.dart';
import '../confirm_alert_dialog.dart';

// Widget buildTrialPitContent(List<TrialPit> trialPits) {
//   if (trialPits.isEmpty) {
//     return const SizedBox(height: 400, child: Center(child: Text('No Activities Found', style: TextStyle(color: Colors.grey, fontSize: 20))));
//   } else {
//     return
//     SizedBox(
//       height: 400,
//       child: Column(
//         children: [
//           ValueListenableBuilder<Box<TrialPit>>(
//             valueListenable: Boxes.geTrialPits().listenable(),
//             builder: (context, box, _) {
//               return trialPitListViewBuilder(context, trialPits);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

//!list view builder
Widget trialPitListViewBuilder(BuildContext context, List<TrialPit> trialPits) {
  return ListView(
    children: [
      ...trialPits.map(
        (e) => Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 219, 219, 219),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.calendar_view_day),
              tilePadding: const EdgeInsets.all(5),
              title: Text('Layer: ${trialPits.lastIndexOf(e) + 1}'),
              subtitle: Text(e.pitNumber),
              // subtitle: Text(
              //     '  type: ${e.type} \n  height: ${e.height.toString()} m'),
              children: [
                buildTrialPitButtons(context, trialPits, e),
              ],
            ),
          ),
        ),
      ),
    ],
  );
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
                onClickedDone: (pitNumber, coords, elevation, layersList) =>
                    editTrialPit(trialPit, pitNumber, coords, elevation, layersList),
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
