import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pit_pro_app/models/job.dart'; 
import 'package:pit_pro_app/models/layer.dart';
import 'package:pit_pro_app/models/trial_pit.dart';
import 'package:pit_pro_app/models/user.dart';

import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialise Hive
  await Hive.initFlutter();

  //register custom class adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(JobAdapter());
  Hive.registerAdapter(TrialPitAdapter());
  Hive.registerAdapter(LayerAdapter());

  //open Hive boxes
  await Hive.openBox<User>('users');
  await Hive.openBox<Job>('jobs');
  await Hive.openBox<TrialPit>('trialPits');
  await Hive.openBox<Layer>('layers');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      showPerformanceOverlay: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}
