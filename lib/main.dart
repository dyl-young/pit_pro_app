//packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

//local imports
import 'pages/home_page.dart';
import 'models/user.dart';
import 'models/job.dart';
import 'models/trial_pit.dart';
import 'models/layer.dart';

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
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      debugShowMaterialGrid:  false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
            thickness: MaterialStateProperty.all(6),
            radius: const Radius.circular(5),
            crossAxisMargin: 2,
            thumbColor: MaterialStateProperty.all(Colors.green)),
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}
