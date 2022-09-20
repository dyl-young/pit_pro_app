import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pit_pro_app/constants/images.dart';

import '../../models/job.dart';
import '../../models/layer.dart';
import '../../models/trial_pit.dart';
import '../../models/user.dart';

Future<Uint8List> pdfBuildPage(User user, Job job) async {
  List<TrialPit> trialPits = job.trialPitList;

  //*To implement if auge/boreholes added
  // List<TrialPit> borholes = job.boreholeList;
  // List<TrialPit> augerPits = job.augerPitList;

  //create document
  final pdf = Document();

  //User Logo:
  final imageLogo = MemoryImage(
      (await rootBundle.load(user.institutionLogo)).buffer.asUint8List());

  //soil symbols:
  final gravel =
      MemoryImage((await rootBundle.load(Images.gravel)).buffer.asUint8List());
  final gravelley = MemoryImage(
      (await rootBundle.load(Images.gravelley)).buffer.asUint8List());
  final clay =
      MemoryImage((await rootBundle.load(Images.clay)).buffer.asUint8List());
  final calyey =
      MemoryImage((await rootBundle.load(Images.calyey)).buffer.asUint8List());
  final silt =
      MemoryImage((await rootBundle.load(Images.silt)).buffer.asUint8List());
  final silty =
      MemoryImage((await rootBundle.load(Images.silty)).buffer.asUint8List());
  final sand =
      MemoryImage((await rootBundle.load(Images.sand)).buffer.asUint8List());
  final sandy =
      MemoryImage((await rootBundle.load(Images.sandy)).buffer.asUint8List());
  final fill =
      MemoryImage((await rootBundle.load(Images.fill)).buffer.asUint8List());
  final roots =
      MemoryImage((await rootBundle.load(Images.roots)).buffer.asUint8List());
  final boulders = MemoryImage(
      (await rootBundle.load(Images.boulders)).buffer.asUint8List());
  final scatteredBouldersoulders = MemoryImage(
      (await rootBundle.load(Images.scatteredBoulders)).buffer.asUint8List());

  //markers
  final wt =
      MemoryImage((await rootBundle.load(Images.wt)).buffer.asUint8List());
  final pwt =
      MemoryImage((await rootBundle.load(Images.pwt)).buffer.asUint8List());
  final pm =
      MemoryImage((await rootBundle.load(Images.pm)).buffer.asUint8List());

  //default image
  final defaultImage = MemoryImage(
      (await rootBundle.load(Images.defaultImage)).buffer.asUint8List());

  //Map of symbols
  Map<String, MemoryImage> symbols = {
    'Logo': imageLogo,
    'Gravel': gravel,
    'Gravelley': gravelley,
    'Clay': clay,
    'Calyey': calyey,
    'Silt': silt,
    'Silty': silty,
    'Sand': sand,
    'Sandy': sandy,
    'Fill': fill,
    'Roots': roots,
    'Boulders': boulders,
    'Scattered Boulders': scatteredBouldersoulders,
    'WT': wt,
    'PWT': pwt,
    'PM': pm,
  };

  //images
  if (trialPits != []) {
    for (var element in trialPits) {
      buildTrialPitPage(pdf, user, job, element, symbols, defaultImage);
    }
  }

  return pdf.save();
}

void buildTrialPitPage(Document pdf, User user, Job job, TrialPit trialPit,
    Map<String, MemoryImage> symbols, MemoryImage defaultImage) async {
  //*variables
  List<Layer> layers = trialPit.layersList;
  double totalDepth = trialPit.totalDepth();
  double cumulativeDepth = 0;

  bool wtFound = false;
  bool pwtFound = false;

  if (trialPit.layersList.isNotEmpty) {
    return pdf.addPage(
      Page(build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //!Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //logo
              Positioned.fill(
                child: Image(symbols['Logo'] ?? defaultImage,
                    height: 140, width: 140),
              ),
              //titles
              Column(children: [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Trial Pit Log',
                        style: const TextStyle(fontSize: 20))),
                Text(user.institutionName),
                Text(job.jobTitle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
              //details
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Hole No:  '),
                  Text(trialPit.pitNumber,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Job No:  '),
                  Text(job.jobNumber,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                ]),
              ]),
            ]),

            //!Spacer
            // SizedBox(height: 5),

            //empty first row (0 m)
            Table(
              children: [
                TableRow(children: [
                  Text('0.0 m', style: const TextStyle(fontSize: 10))
                ]),
              ],
            ),

            //!Main table
            Table(
              // *border
              border: const TableBorder(
                top: BorderSide(color: PdfColors.black),
                bottom: BorderSide(color: PdfColors.black),
                right: BorderSide(color: PdfColors.black),
                horizontalInside: BorderSide(color: PdfColors.black),
                verticalInside: BorderSide(color: PdfColors.black),
              ),
              //*Col widths
              tableWidth: TableWidth.max,
              columnWidths: {
                // 0: const FlexColumnWidth(2),
                // 1: const FlexColumnWidth(2),
                // 2: const FlexColumnWidth(1.5),
                // 3: const FlexColumnWidth(20),
                0: const FixedColumnWidth(32),
                1: const FixedColumnWidth(32.5),
                2: const FixedColumnWidth(32),
                3: const FixedColumnWidth(360),
              },

              //*Layer row
              //TODO: Test all images
              children: List<TableRow>.generate(
                layers.length,
                (int i) {
                  double wtDepth = trialPit.wtDepth ?? 0;
                  double pwtDepth = trialPit.pwtDepth ?? 0;
                  double pmDepth = layers[i].pmDepth ?? 0;
                  double height = 512 * (layers[i].depth / totalDepth);
                  cumulativeDepth += layers[i].depth;

                  if (cumulativeDepth >= wtDepth &&
                      wtDepth != 0 &&
                      wtFound == false) {
                    wtFound = true;
                    layers[i].wtDepth = wtDepth;
                  }
                  if (cumulativeDepth >= pwtDepth &&
                      pwtDepth != 0 &&
                      pwtFound == false) {
                    pwtFound = true;
                    layers[i].pwtDepth = pwtDepth;
                  }
                  if (pmDepth != 0) {
                    pmDepth += (cumulativeDepth - layers[i].depth);
                  }

                  return TableRow(
                    children: [
                      //! col 1: depth
                      SizedBox(
                        height: height,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${cumulativeDepth.toString()} m',
                                  style: const TextStyle(fontSize: 10)),
                            ]),
                      ),

                      //! col 2: symbols
                      Stack(
                          children: symbolOverlayCol(
                              symbols, defaultImage, layers[i], height)),

                      //! col 3: marker
                      SizedBox(
                        height: height,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //* Pebble Marker
                              (layers[i].pmDepth != 0)
                                  ? Column(children: [
                                      Text('${pmDepth.toString()} m',
                                          style: const TextStyle(fontSize: 8)),
                                      Image(symbols['PM'] ?? defaultImage,
                                          height: 20, width: 20)
                                    ])
                                  : SizedBox.shrink(),
                              //*Water table
                              (layers[i].wtDepth != 0)
                                  ? Column(children: [
                                      Text('${layers[i].wtDepth.toString()} m',
                                          style: const TextStyle(fontSize: 8)),
                                      Image(symbols['WT'] ?? defaultImage,
                                          height: 20, width: 20)
                                    ])
                                  : SizedBox.shrink(),
                              //*Perched Water table
                              (layers[i].pwtDepth != 0)
                                  ? Column(children: [
                                      Text('${layers[i].pwtDepth.toString()} m',
                                          style: const TextStyle(fontSize: 8)),
                                      Image(symbols['PWT'] ?? defaultImage,
                                          height: 20, width: 20)
                                    ])
                                  : SizedBox.shrink(),
                            ]),
                      ),

                      //! col 4: Details
                      // Text('3'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Layer details:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '${layers[i].moisture}, ${layers[i].colour}, ${layers[i].consistency}, ${layers[i].soilToString()}, ${layers[i].structure}, ${layers[i].originType}: ${layers[i].origin}'),
                          Text('Notes:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${layers[i].notes}')
                        ],
                      ),
                    ],
                  );
                  // return buildLayerInfo(trialPit.layersList[i], trialPit.totalDepth(), symbols, defaultImage);
                },
              ),
            ),

            //!Spacer
            SizedBox(height: 5),

            //!Notes  //? 4 lines 33 characters.
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notes Area:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        '1) Water Table: ${trialPit.wtDepth != 0 ? 'at ${trialPit.wtDepth} m' : 'None'}'),
                    Text(
                        '2) Perched Water Table: ${trialPit.pwtDepth != 0 ? 'at ${trialPit.pwtDepth} m' : 'None'}'),
                    // Text('3) Pebble Marker: ${trialPit.wtDepth != 0 ? 'at ${trialPit.wtDepth} m' : 'None'}'),
                    //TODO: add pebble marker list to Trial Pit and display
                  ],
                ),
              ),
              //TODO: Implement Trial Pit notes
              SizedBox(
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('4) notes text area'),
                    // Text('5) notes text area'),
                    // Text('6) notes text area'),
                    // Text('7) 123456789812345678901234567890', maxLines: 1),
                  ],
                ),
              ),
            ]),

            //!Spacer
            SizedBox(height: 5),

            //!footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //titles
                //details
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User: ${user.userName}'),
                      Text(
                          'Date Created : ${trialPit.createdDate.day}-${trialPit.createdDate.month}-${trialPit.createdDate.year}'),
                    ]),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     //TODO: implement contractor and machine in Job
                //     Text('Contractor: 123 Civils'),
                //     Text('Machnine: big ol digger'),
                //   ],
                // ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     //TODO: Implememht inclinations and diameter in Trial pit
                //     Text('Inclination: Vertical'),
                //     Text('Hole Diam: 1 m'),
                //   ],
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        //? 2 rounding options
                        'Location: ${roundDouble(trialPit.coordinates[0], 2)}, ${double.parse(trialPit.coordinates[1].toString()).toStringAsFixed(2)}'), //${loc.longitude} ; ${loc.latitude}'),
                    Text('Elevation: ${trialPit.elevation!.round()} m'),
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  } else {
    return pdf.addPage(Page(
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //!Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //logo
              Positioned.fill(
                child: Image(symbols['Logo'] ?? defaultImage,
                    height: 140, width: 140),
              ),
              //titles
              Column(children: [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Trial Pit Log',
                        style: const TextStyle(fontSize: 20))),
                Text(user.institutionName),
                Text(job.jobTitle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
              //details
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Hole No:  '),
                  Text(trialPit.pitNumber,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Job No:  '),
                  Text(job.jobNumber,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                ]),
              ]),
            ]),
            SizedBox(height: 250),
            Center(
                child: Text("No Layer Content Added",
                    style:
                        const TextStyle(fontSize: 20, color: PdfColors.grey)))
          ],
        );
      },
    ));
  }
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

List<Widget> symbolOverlayCol(Map<String, MemoryImage> symbols,
    MemoryImage defaultImage, Layer layer, double height) {
  List<String> soilTypes = layer.soilTypes;
  List<Expanded> columns = [];

  for (var element in soilTypes) {
    columns.add(Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                buildSoilSymbols(height, symbols[element] ?? defaultImage))));
  }

  return columns;
}

List<Widget> buildSoilSymbols(double height, ImageProvider image) {
  // var temp = height % 65;
  var count = (height) / 32;
  List<Widget> imageList = [];
  for (var i = 0; i < (count); i++) {
    imageList.add(SizedBox(
        height: 32, width: 34, child: Image(image, fit: BoxFit.fitWidth)));
    //?try boxfit.contains
  }
  return imageList;
}

// bool checkWT(double cumulativeDepth, double wtDepth){
//     bool found;

//     cumulativeDepth > wtDepth ? found = true : found = false;

//     return found;
// }
// checkPWT(),
// checkPM()

TableRow buildLayerInfo(Layer layer, double totalDepth,
    Map<String, MemoryImage> symbols, MemoryImage defaultImage) {
  double height =
      1000 * (layer.depth / totalDepth) + 30 * (layer.depth / totalDepth);
  // double height = 565 * (layer.depth / totalDepth);
  print(height);

  return TableRow(
    children: [
      //!col 1: Height marker
      SizedBox(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('${layer.depth} m'),
          ],
        ),
      ),

      //! col 2: Symbols
      Column(
        children: buildSoilSymbols(height, symbols['Sand'] ?? defaultImage),
      ),

      //TODO: fix the implemntation of the maker
      //! col 3: marker symbols.
      // SizedBox(height: h / 2, child: Image(pwtSymbol)),

      //! col 4: layer details
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Layer details: ${layer.moisture}, ${layer.colour}, ${layer.consistency}, ${layer.soilToString()}, ${layer.structure}'),
          Text('Notes: ${layer.notes}')
        ],
      ),
    ],
  );
}
