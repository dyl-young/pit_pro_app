
class Images {
  Images._();

  static const String logo = 'assets/su_logo.png';

  static const String gravel = 'assets/Gravel.png';  
  static const String gravelly = 'assets/Gravelly.png'; //TODO: FIX
  static const String clay = 'assets/Clay.png';           
  static const String clayey = 'assets/Clayey.png';       //TODO: FIX
  static const String silt = 'assets/Silt.png';           
  static const String silty = 'assets/Silty.png';     
  static const String sand = 'assets/Sand.png';
  static const String sandy = 'assets/Sandy.png';
  static const String fill = 'assets/Fill.png';
  static const String roots = 'assets/Roots.png';
  static const String boulders = 'assets/Boulders.png';
  static const String scatteredBoulders = 'assets/Scattered Boulders.png';

  static const String wt = 'assets/WT.png';
  static const String pwt = 'assets/PWT.png';
  static const String pm = 'assets/PM.png';

  static const String defaultImage = 'assets/Default_Image.png';
}

// Future<MemoryImage> pics() async {
// MemoryImage picture = MemoryImage((await rootBundle.load('assets/$Images.logo')).buffer.asUint8List());
// return picture;
// }