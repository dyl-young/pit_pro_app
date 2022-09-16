import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../models/layer.dart';

class LayerFormPage extends StatefulWidget {
  const LayerFormPage({Key? key, this.layer}) : super(key: key);
   //*class arguments
  final Layer? layer;
  // final Function() onClickedDone;

  @override
  State<LayerFormPage> createState() => _LayerFormPageState();
}

class _LayerFormPageState extends State<LayerFormPage> {
  @override
  Widget build(BuildContext context) {
    //detrmine title
    final isEditing = widget.layer != null;
    final title = isEditing ? 'Edit Layer' : 'Create Layer';

    return WillPopScope(
      //disable back device button on this page
      onWillPop: () async => false,
      child: Scaffold(
        //! appbar
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          //*disable automatic back button
          automaticallyImplyLeading: false,

          //*Cancel button
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cancelButton(context, [], !isEditing),
            ),
          ],
        ),
      ),
    );
  }
}
