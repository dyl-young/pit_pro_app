//packages
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

//local imports
import '../../models/job.dart';
import '../../models/user.dart';
import '../pdf/pdf_build_page.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({Key? key, required this.job, required this.user})
      : super(key: key);

  final User user;
  final Job job;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        title: const Center(child: Text("PDF Profile Log")),
      ),
      body: PdfPreview(
        loadingWidget: const CircularProgressIndicator(
          color: Colors.green,
          backgroundColor: Colors.white,
          strokeWidth: 6,
        ),
        pdfFileName: 'Trialpit_Log_${widget.job.jobNumber}.pdf',
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        build: (context) => pdfBuildPage(widget.user, widget.job),
      ),
    );
  }
}
