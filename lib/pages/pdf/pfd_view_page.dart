import 'package:flutter/material.dart';
import 'package:pit_pro_app/pages/pdf/pdf_build_page.dart';
import 'package:printing/printing.dart';

import '../../models/job.dart';
import '../../models/user.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({Key? key, required this.job, required this.user}) : super(key: key);

  final User user;
  final Job job;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("PDF Profile Log")),
      ),
      body: PdfPreview(
        build: (context) => pdfBuildPage(widget.user, widget.job),
      ));
}
