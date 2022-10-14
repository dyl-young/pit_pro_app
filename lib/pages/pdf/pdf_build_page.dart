//* libraries
import 'dart:io' as io;
import 'dart:math';
import 'dart:typed_data';

//* packages
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

//* local imports
import '../../constants/images.dart';
import '../../models/job.dart';
import '../../models/layer.dart';
import '../../models/trial_pit.dart';
import '../../models/user.dart';

Future<Uint8List> pdfBuildPage(User user, Job job) async {
  //* attributes
  List<TrialPit> trialPits = job.trialPitList;

  // create document
  final pdf = Document();

  // user Logo:
  final MemoryImage appLogo = MemoryImage(
      (await rootBundle.load('assets/app_logo.png')).buffer.asUint8List());

  final MemoryImage imageLogo;
  (user.institutionLogo != 'assets/app_logo.png')
      ? imageLogo = MemoryImage(io.File(user.institutionLogo).readAsBytesSync())
      : imageLogo = appLogo;

  // soil symbols:
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

  // markers
  final wt =
      MemoryImage((await rootBundle.load(Images.wt)).buffer.asUint8List());
  final smpl =
      MemoryImage((await rootBundle.load(Images.smpl)).buffer.asUint8List());

  // default image
  final defaultImage = MemoryImage(
      (await rootBundle.load(Images.defaultImage)).buffer.asUint8List());

  // map of symbols
  Map<String, MemoryImage> images = {
    'Default Image': defaultImage,
    'App Logo': appLogo,
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
    'SMPL': smpl,
  };

  //* trial pit page
  if (trialPits != []) {
    for (var element in trialPits) {
      buildTrialPitPage(pdf, user, job, element, images, defaultImage);

      //* trial pit image page
      if (element.imagePath != '') {
        addtrialPitImage(pdf, element.imagePath!, element, job);
      }
    }
    //* legend page
    addSymbolLegendPage(pdf, images, defaultImage);
  }

  return pdf.save();
}

//! build trial pit page layout
void buildTrialPitPage(Document pdf, User user, Job job, TrialPit trialPit,
    Map<String, MemoryImage> images, MemoryImage defaultImage) async {
  //*variables
  List<Layer> layers = trialPit.layersList;
  double totalDepth = trialPit.totalDepth();
  double cumulativeDepth = 0;
  double tableHeight = 500;
  double scale = totalDepth / (.18);

  Map<int, double> smplLayers = {};

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
                  //! header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //* logo
                      Image(
                        images['Logo'] ?? defaultImage,
                        height: 60,
                        width: 120,
                      ),

                      //* title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Trial Pit Log',
                              style: const TextStyle(fontSize: 20)),
                          Text(user.institutionName),
                          Text(job.jobTitle),
                        ],
                      ),

                      //* details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Text('Hole No: ${trialPit.pitNumber}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Text('Job No:  ${job.jobNumber}',
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // spacer
                  SizedBox(height: 5),

                  Table(
                    children: [
                      //graph scale
                      TableRow(children: [
                        Text('Scale   1 : ${roundDouble(scale, 1)} ',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      // 0 m depth
                      TableRow(children: [
                        Text('0.0 m', style: const TextStyle(fontSize: 10)),
                      ]),
                    ],
                  ),

                  //! main table
                  Table(
                    //* border
                    border: const TableBorder(
                      top: BorderSide(color: PdfColors.black),
                      bottom: BorderSide(color: PdfColors.black),
                      right: BorderSide(color: PdfColors.black),
                      horizontalInside: BorderSide(color: PdfColors.black),
                      verticalInside: BorderSide(color: PdfColors.black),
                    ),

                    //* col widths
                    tableWidth: TableWidth.max,
                    columnWidths: {
                      0: const FixedColumnWidth(32),
                      1: const FixedColumnWidth(30),
                      2: const FixedColumnWidth(32),
                      3: const FixedColumnWidth(360),
                    },

                    //* Layer row
                    children: List<TableRow>.generate(
                      layers.length,
                      (int i) {
                        //*row heights:
                        double wtDepth = trialPit.wtDepth ?? 0;
                        double smplDepth = layers[i].smplDepth ?? 0;
                        double height = tableHeight * (layers[i].depth / totalDepth);
                        double colHeight = roundDouble(height / 32, 0) * 32;
                        double marker1 = 0;
                        String text1;
                        double marker2 = 0;
                        String text2;

                        cumulativeDepth += layers[i].depth;
                        
                        String otherColour;
                        layers[i].otherColour != ''
                            ? otherColour = ', ${layers[i].otherColour}, '
                            : otherColour = ', ';

                        if (cumulativeDepth >= wtDepth && wtDepth != 0 && wtFound == false) {
                          wtFound = true;
                          layers[i].wtDepth = wtDepth;

                        } else {
                          layers[i].wtDepth = 0;
                        }

                        if (smplDepth != 0) {
                          smplDepth += (cumulativeDepth - layers[i].depth);
                          smplLayers.putIfAbsent(i, () => smplDepth);
                        }

                        if(layers[i].smplDepth! <= layers[i].wtDepth!){
                          marker1 = layers[i].smplDepth!;
                          text1 = 'SMPL';
                          marker2 = layers[i].wtDepth!;
                          text2 = 'WT';
                        }else{
                          marker1 = layers[i].wtDepth!;
                          text1 = 'WT';
                          marker2 = layers[i].smplDepth!;
                          text2 = 'SMPL';
                        }

                        return TableRow(
                          children: [
                            //* col 1: depth
                            SizedBox(
                              height: colHeight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${(roundDouble(cumulativeDepth, 2)).toString()} m', style: const TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),

                            //* col 2: symbols
                            Stack(children: symbolOverlayCol(images, defaultImage, layers[i], height)),

                            //* col 3: markers for water table and samples
                            SizedBox(
                              height: colHeight,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  
                                  //* 1st marker
                                  (marker1 != 0)
                                  ? Column(
                                      children: [
                                        Text('${roundDouble(marker1, 2).toString()} m', style: const TextStyle(fontSize: 8)),
                                        Image(images[text1] ?? defaultImage, height: 20, width: 20)
                                      ],
                                    )
                                  : SizedBox.shrink(),

                                  //* 2nd marker
                                  (marker2 != 0)
                                  ? Column(
                                      children: [
                                        Text('${roundDouble(marker2, 2).toString()} m', style: const TextStyle(fontSize: 8)),
                                        Image(images[text2] ?? defaultImage, height: 20, width: 20)
                                      ],
                                    )
                                  : SizedBox.shrink(),
                                ],
                              ),
                            ),

                            //* col 4: Details
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
                                        '${layers[i].moisture}, ${layers[i].colourPattern}${layers[i].colour}$otherColour${layers[i].consistency}, ${layers[i].soilToString()}, ${layers[i].structure}, ${layers[i].originType}: ${layers[i].origin}'),
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

                  // spacer
                  SizedBox(height: 5),

                  //! notes
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: 190,
                      height: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Trial Pit Notes:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '1) Water table: ${trialPit.wtDepth != 0 ? 'at ${roundDouble(trialPit.wtDepth!, 2)} m' : 'None'}'),
                          Text(
                              '2) Pebble marker: ${trialPit.pmDepth != 0 ? 'at ${roundDouble(trialPit.pmDepth!, 2)} m' : 'None'}'),
                          Text('3) Samples: ${smplOutput(smplLayers)}',
                              maxLines: 3),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 250,
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          trialPit.notes != ''
                              ? Text('4) ${trialPit.notes}', maxLines: 5)
                              : Text('')
                        ],
                      ),
                    ),
                  ]),
                ],
              ),

              //! footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //* col 1
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Logged by: ${user.userName}'),
                      Text(
                          'Date Created: ${trialPit.createdDate.day}-${trialPit.createdDate.month}-${trialPit.createdDate.year}'),
                    ],
                  ),
                  //* col 2
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contractor: ${trialPit.contractor}'),
                      Text('Machnine: ${trialPit.machine}'),
                    ],
                  ),
                  //* col 3
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Location: ${roundDouble(trialPit.coordinates[0], 2)}, ${roundDouble(trialPit.coordinates[0], 2)}'), //${loc.longitude} ; ${loc.latitude}'),
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
    //! empty trial pit page
    return pdf.addPage(Page(
      build: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header 2
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

            // body: No Content
            SizedBox(
              height: 520,
              child: Center(
                  child: Text("No Layer Content Added",
                      style: const TextStyle(
                          fontSize: 20, color: PdfColors.grey))),
            ),

            // Spacer 2
            SizedBox(height: 5),

            // footer 2
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
                  ],
                ),
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
                        'Location: ${roundDouble(trialPit.coordinates[0], 2)}, ${roundDouble(trialPit.coordinates[0], 2)}'),
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

//! add a new page to display trial pit page
void addtrialPitImage(
    Document pdf, String path, TrialPit trialPit, Job job) async {
  return pdf.addPage(
    Page(
      build: (context) {
        return Expanded(
          // header
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 120),
                Text('Trial Pit Image', style: const TextStyle(fontSize: 20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hole No: ${trialPit.pitNumber}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Job No:  ${job.jobNumber}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            // trial pit image
            SizedBox(
                height: 650,
                child: Image(MemoryImage(io.File(path).readAsBytesSync()),
                    fit: BoxFit.contain)),
          ]),
        );
      },
    ),
  );
}

//! Add legend page for soil symbols
void addSymbolLegendPage(Document pdf, Map<String, MemoryImage> symbols,
    MemoryImage defaultImage) async {
  return pdf.addPage(Page(
    build: (context) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* heading
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Soil Symbol Legend', style: const TextStyle(fontSize: 20))
              ],
            ),

            SizedBox(height: 30),

            //* legend table
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLegendRow(
                        symbols['Boulders'] ?? defaultImage, 'Boulders'),
                    buildLegendRow(symbols['Gravel'] ?? defaultImage, 'Gravel'),
                    buildLegendRow(symbols['Sand'] ?? defaultImage, 'Sand'),
                    buildLegendRow(symbols['Silt'] ?? defaultImage, 'Silt'),
                    buildLegendRow(symbols['Clay'] ?? defaultImage, 'Clay'),
                    buildLegendRow(symbols['Roots'] ?? defaultImage, 'Roots'),
                    buildLegendRow(symbols['Fill'] ?? defaultImage, 'Fill'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLegendRow(
                        symbols['Scattered Boulders'] ?? defaultImage,
                        'Scattered Boulders'),
                    buildLegendRow(
                        symbols['Gravelly'] ?? defaultImage, 'Gravelly'),
                    buildLegendRow(symbols['Sandy'] ?? defaultImage, 'Sandy'),
                    buildLegendRow(symbols['Silty'] ?? defaultImage, 'Silty'),
                    buildLegendRow(symbols['Clayey'] ?? defaultImage, 'Clayey'),
                    buildLegendRow(
                        symbols['WT'] ?? defaultImage, 'Water Table'),
                    buildLegendRow(symbols['SMPL'] ?? defaultImage, 'Sample'),
                    buildLegendRow(symbols['Default Image'] ?? defaultImage,
                        'Default Image'),
                  ],
                )
              ],
            ),

            //* footer
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Created with '),
                      Image(symbols['App Logo'] ?? defaultImage,
                          fit: BoxFit.contain, height: 25, width: 25)
                    ])
                  ]),
            )
          ],
        ),
      );
    },
  ));
}

//! build legeng images/label row
Widget buildLegendRow(MemoryImage image, String label) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        SizedBox(
          height: 32,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: PdfColors.black)),
            child: Padding(
                padding: const EdgeInsets.all(1),
                child: Image(image, fit: BoxFit.scaleDown)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(label),
        ),
      ]));
}

//! trial pit samples output text
String smplOutput(Map<int, double> smplLayers) {
  String result = '';
  int index = 1;
  smplLayers.isNotEmpty
      ? smplLayers.forEach(
          (key, value) {
            result += '$index at ${roundDouble(value, 2)} m, ';
            index++;
          },
        )
      : result = 'None';
  return result;
}

//! round off doubles
double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

//! builds list of soil columns for stack to overlay
List<Widget> symbolOverlayCol(Map<String, MemoryImage> symbols,
    MemoryImage defaultImage, Layer layer, double height) {
  List<String> soilTypes = layer.soilTypes;
  List<Expanded> columns = [];

  for (var element in soilTypes) {
    columns.add(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildSoilSymbols(height, symbols[element] ?? defaultImage),
        ),
      ),
    );
  }
  return columns;
}

//! builds image list of soil symbols for Column
List<Widget> buildSoilSymbols(double height, ImageProvider image) {
  int count = ((height) / 32).round();
  List<Widget> imageList = [];
  for (var i = 0; i < (count); i++) {
    imageList
        .add(SizedBox(height: 32, child: Image(image, fit: BoxFit.contain)));
  }
  return imageList;
}

Widget marker ( Map<String, MemoryImage> images, MemoryImage defaultImage, double depth,String text){
  return (depth != 0)
    ? Column(
        children: [
          Text('${roundDouble(depth, 2).toString()} m', style: const TextStyle(fontSize: 8)),
          Image(images['text'] ?? defaultImage, height: 20, width: 20)
        ],
      )
    : SizedBox.shrink();
}