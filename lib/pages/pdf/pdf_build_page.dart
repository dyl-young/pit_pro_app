import 'dart:io' as io;
import 'dart:math';
import 'dart:typed_data';

//packages
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

//local imports
import '../../constants/images.dart';
import '../../models/job.dart';
import '../../models/layer.dart';
import '../../models/trial_pit.dart';
import '../../models/user.dart';

Future<Uint8List> pdfBuildPage(User user, Job job) async {
  List<TrialPit> trialPits = job.trialPitList;

  //*To implement if auge/boreholes added

  //create document
  final pdf = Document();

  //User Logo:
  final MemoryImage imageLogo;

  (user.institutionLogo != 'assets/app_logo.png')
      ? imageLogo = MemoryImage(io.File(user.institutionLogo).readAsBytesSync())
      : imageLogo = MemoryImage(
          (await rootBundle.load('assets/app_logo.png')).buffer.asUint8List());

  //soil symbols:
  final gravel =
      MemoryImage((await rootBundle.load(Images.gravel)).buffer.asUint8List());
  final gravelly = MemoryImage(
      (await rootBundle.load(Images.gravelly)).buffer.asUint8List());
  final clay =
      MemoryImage((await rootBundle.load(Images.clay)).buffer.asUint8List());
  final clayey =
      MemoryImage((await rootBundle.load(Images.clayey)).buffer.asUint8List());
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
  final pm =
      MemoryImage((await rootBundle.load(Images.pm)).buffer.asUint8List());

  //default image
  final defaultImage = MemoryImage(
      (await rootBundle.load(Images.defaultImage)).buffer.asUint8List());

  //Map of symbols
  Map<String, MemoryImage> images = {
    'Logo': imageLogo,
    'Gravel': gravel,
    'Gravelly': gravelly,
    'Clay': clay,
    'Clayey': clayey,
    'Silt': silt,
    'Silty': silty,
    'Sand': sand,
    'Sandy': sandy,
    'Fill': fill,
    'Roots': roots,
    'Boulders': boulders,
    'Scattered Boulders': scatteredBouldersoulders,
    'WT': wt,
    'PM': pm,
  };

  //images
  if (trialPits != []) {
    for (var element in trialPits) {
      buildTrialPitPage(pdf, user, job, element, images, defaultImage);
      if (element.imagePath != '') {
        addtrialPitImage(pdf, element.imagePath!);
      }
    }
  }

  return pdf.save();
}

void addtrialPitImage(Document pdf, String path) async {
  return pdf.addPage(
    Page(
      build: (context) {
        return Image(MemoryImage(io.File(path).readAsBytesSync()));
      },
    ),
  );
}

void buildTrialPitPage(Document pdf, User user, Job job, TrialPit trialPit,
    Map<String, MemoryImage> images, MemoryImage defaultImage) async {
  //*variables
  List<Layer> layers = trialPit.layersList;
  double totalDepth = trialPit.totalDepth();
  double cumulativeDepth = 0;

  bool wtFound = false;

  if (trialPit.layersList.isNotEmpty) {
    return pdf.addPage(
      Page(build: (context) {
        return SizedBox(
          height: 728, //total vertical space

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  //!Header
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //*logo
                        Image(
                          images['Logo'] ?? defaultImage,
                          height: 60,
                          width: 120,
                        ),

                        //*titles
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trial Pit Log',
                                  style: const TextStyle(fontSize: 20)),
                              Text(user.institutionName),
                              Text(job.jobTitle),
                              // style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),

                        //details
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Hole No:  '),
                                      Text(trialPit.pitNumber,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14))
                                    ]),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Job No:  '),
                                      Text(job.jobNumber,
                                          style: const TextStyle(fontSize: 14))
                                    ]),
                              ),
                            ]),
                      ]),

                  //!Spacer
                  SizedBox(height: 5),

                  //!empty first row (0 m)
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
                      0: const FixedColumnWidth(32),
                      1: const FixedColumnWidth(30),
                      2: const FixedColumnWidth(32),
                      3: const FixedColumnWidth(360),
                    },

                    //*Layer row
                    children: List<TableRow>.generate(
                      layers.length,
                      (int i) {
                        //*row heights:
                        double wtDepth = trialPit.wtDepth ?? 0;
                        double pmDepth = layers[i].pmDepth ?? 0;
                        double height = 500 * (layers[i].depth / totalDepth);
                        double colHeight = roundDouble(height / 32, 0) * 32;
                        cumulativeDepth += layers[i].depth;

                        if (cumulativeDepth >= wtDepth &&
                            wtDepth != 0 &&
                            wtFound == false) {
                          wtFound = true;
                          layers[i].wtDepth = wtDepth;
                        } else {
                          layers[i].wtDepth = 0;
                        }
                        if (pmDepth != 0) {
                          pmDepth += (cumulativeDepth - layers[i].depth);
                        }

                        return TableRow(
                          children: [
                            //! col 1: depth
                            SizedBox(
                              height: colHeight,
                              child: Column(
                                  // mainAxisSize: MainAxisSize.max,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('${cumulativeDepth.toString()} m',
                                        style: const TextStyle(fontSize: 10)),
                                  ]),
                            ),

                            //! col 2: symbols
                            Stack(
                                children: symbolOverlayCol(
                                    images, defaultImage, layers[i], height)),

                            //! col 3: marker
                            SizedBox(
                              height: colHeight,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // //* Pebble Marker
                                  (layers[i].pmDepth != 0)
                                      ? Column(
                                          children: [
                                            Text(
                                              '${pmDepth.toString()} m',
                                              style:
                                                  const TextStyle(fontSize: 8),
                                            ),
                                            Image(images['PM'] ?? defaultImage,
                                                height: 20, width: 20)
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //*Water table
                                  (layers[i].wtDepth != 0)
                                      ? Column(
                                          children: [
                                            Text(
                                              '${layers[i].wtDepth.toString()} m',
                                              style:
                                                  const TextStyle(fontSize: 8),
                                            ),
                                            Image(images['WT'] ?? defaultImage,
                                                height: 20, width: 20)
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),

                            //! col 4: Details
                            // Text('3'),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Layer ${i + 1} details:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                        '${layers[i].moisture}, ${layers[i].colourPattern}${layers[i].colour}, ${layers[i].consistency}, ${layers[i].soilToString()}, ${layers[i].structure}, ${layers[i].originType}: ${layers[i].origin}'),
                                  ),
                                  Text('Notes:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('${layers[i].notes}')
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  //!Spacer
                  SizedBox(height: 5),
                  //!Notes
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: 180,
                      height: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notes Area:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '1) Water Table: ${trialPit.wtDepth != 0 ? 'at ${trialPit.wtDepth} m' : 'None'}'),
                          Text('2) Pebble marker/disturbed soil'),
                          Text('3) maybe refusal?'),

                          //TODO: add pebble marker list to Trial Pit and display
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('${trialPit.notes}', maxLines: 5)],
                      ),
                    ),
                  ]),
                ],
              ),

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
                        Text('Logger: ${user.userName}'),
                        Text(
                            'Date Created : ${trialPit.createdDate.day}-${trialPit.createdDate.month}-${trialPit.createdDate.year}'),
                      ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contractor: ${trialPit.contractor}'),
                      Text('Machnine: ${trialPit.machine}'),
                    ],
                  ),
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
          ),
        );
      }),
    );
  } else {
    return pdf.addPage(Page(
      build: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //!Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //logo
              Image(images['Logo'] ?? defaultImage, height: 60, width: 120),
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
                  Text(job.jobNumber, style: const TextStyle(fontSize: 14))
                ]),
              ]),
            ]),
            SizedBox(
              height: 520,
              child: Center(
                  child: Text("No Layer Content Added",
                      style: const TextStyle(
                          fontSize: 20, color: PdfColors.grey))),
            ),

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
                      Text('Logger: ${user.userName}'),
                      Text(
                          'Date Created : ${trialPit.createdDate.day}-${trialPit.createdDate.month}-${trialPit.createdDate.year}'),
                    ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contractor: ${trialPit.contractor}'),
                    Text('Machnine: ${trialPit.machine}'),
                  ],
                ),
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
      },
    ));
  }
}

//! Round off Doubles
double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

//! Builds list of soil columns for stack to overlay
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

//! Builds image list of soil symbols for Column
List<Widget> buildSoilSymbols(double height, ImageProvider image) {
  // var temp = height % 32;
  int count = ((height) / 32).round();
  List<Widget> imageList = [];
  for (var i = 0; i < (count); i++) {
    imageList
        .add(SizedBox(height: 32, child: Image(image, fit: BoxFit.contain)));
    //?try boxfit.contains
  }
  return imageList;
}
