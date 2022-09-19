import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart';

import '../../models/job.dart';
import '../../models/trial_pit.dart';
import '../../models/user.dart';

Future<Uint8List> pdfBuildPage(User user, Job job) async {
  List<TrialPit> trialPits = job.trialPitList;

  //*To implement if auge/boreholes added
  // List<TrialPit> borholes = job.boreholeList;
  // List<TrialPit> augerPits = job.augerPitList;

  //create document
  final pdf = Document();

  //User content:
  // final imageLogo = MemoryImage(
  //   (await rootBundle.load('assets/${user.institutionLogo}'))
  //       .buffer
  //       .asUint8List(),
  // );

  //images
  if (trialPits != []) {
    for (var element in trialPits) {
      buildTrialPitPage(pdf, element);
    }
  }

  return pdf.save();
}

void buildTrialPitPage(Document pdf, TrialPit trialPit) {
  return pdf.addPage(
    Page(build: (context) {
      return Column(children: [Text(trialPit.pitNumber)]);
    }),
  );
}
