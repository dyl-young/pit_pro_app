  // ignore_for_file: constant_identifier_names

class SoilMoisture {
  static const String DRY = 'Dry';
  static const String S_MOIST = 'Slightly Moist';
  static const String MOIST = 'Moist';
  static const String V_MOIST = 'Very Moist';
  static const String WET = 'Wet';

  List<String> getSoilMoisture() {
    return [DRY, S_MOIST, MOIST, V_MOIST, WET];
  }
}

class SoilColour {
  static const String D_BROWN = 'Dark Brown';
  static const String M_BROWN = 'Medium Brown';
  static const String L_BROWN = 'Light Brown';
  static const String D_RED_BROWN = 'Dark Red-Brown';
  static const String L_RED_BROWN = 'Light Red-Brown';
  static const String L_YELLOW = 'Light Yellow';
  static const String D_YELLOW_BROWN = 'Dark Yellow-Brown';
  static const String L_YELLOW_BROWN = 'Light Yellow-Brown';
  static const String D_GREEN_BROWN = 'Dark Green-Brown';
  static const String L_GREEN_BROWN = 'Light Green-Brown';
  static const String D_ORANGE_BROWN = 'Dark Orange-Brown';
  static const String L_ORANGE_BROWN = 'Light Orange-Brown';
  static const String D_GREY = 'Dark Grey';
  static const String M_GREY = 'Medium Grey';
  static const String L_GREY = 'Light Grey';
  static const String D_BLUE_GREY = 'Dark Blue-Grey';
  static const String L_BLUE_GREY = 'Light Blue-Grey';
  static const String D_YELLOW_GREY = 'Dark Yellow-Grey';
  static const String L_YELLOW_GREY = 'Light Yellow-Grey';
  static const String D_GREEN_GREY = 'Dark Green-Grey';
  static const String L_GREEN_GREY = 'Light Green-Grey';
  static const String D_OLIVE = 'Dark Olive';
  static const String M_OLIVE = 'Medium Olive';
  static const String L_OLIVE = 'Light Olive';

  List<String> getSoilColour() {
    return [
      D_BROWN,
      M_BROWN,
      L_BROWN,
      D_RED_BROWN,
      L_RED_BROWN,
      L_YELLOW,
      D_YELLOW_BROWN,
      L_YELLOW_BROWN,
      D_GREEN_BROWN,
      L_GREEN_BROWN,
      D_ORANGE_BROWN,
      L_ORANGE_BROWN,
      D_GREY,
      M_GREY,
      L_GREY,
      D_BLUE_GREY,
      L_BLUE_GREY,
      D_YELLOW_GREY,
      L_YELLOW_GREY,
      D_GREEN_GREY,
      L_GREEN_GREY,
      D_OLIVE,
      M_OLIVE,
      L_OLIVE
    ];
  }
}

class SoilConsistency {

  //! Cohesive Consistency
  static const String V_SOFT = 'Very Soft';
  static const String SOFT = 'Soft';
  static const String FIRM = 'Firm';
  static const String STIFF = 'Stiff';
  static const String V_STIFF = 'Very Stiff';

  // !Granular Consistency
  static const String V_LOOSE = 'Very Loose';
  static const String LOOSE = 'Loose';
  static const String M_DENSE = 'Medium Dense';
  static const String DENSE = 'Dense';
  static const String V_DENSE = 'Very Dense';

  List<String> getCohesiveConsistency() {
    return [V_SOFT, SOFT, FIRM, STIFF, V_STIFF];
  }

  List<String> getGranularConsistency() {
    return [V_LOOSE, LOOSE, M_DENSE, DENSE, V_DENSE];
  }
}

class SoilTypes {
  //! Primary Soil
  static const String ROOTS = 'Roots';
  static const String FILL = 'Fill';
  static const String BOULDERS = 'Boulders'; //[Secondary Soil] with boulders

  static const String GRAVEL = 'Garvel';
  static const String SAND = 'Sand';
  static const String SILT = 'Silt';
  static const String CLAY = 'Clay';

  //! Secondary Soil
  static const String L_BOULDERS ='Scattered Boulders'; //Scattered Boulders in [Primary Soil]
  static const String L_GRAVEL = 'Garvelly';
  static const String L_SAND = 'Sandy';
  static const String L_SILT = 'Silty';
  static const String L_CLAY = 'Clayey';

  //TODO: provide rock types if there is time

  List<String> getPrimSoilTypes() {
    return [GRAVEL, SAND, SILT, CLAY, ROOTS, FILL, BOULDERS];
  }

  List<String> getSecSoilTypes() {
    return [L_GRAVEL, L_SAND, L_SILT, L_CLAY, L_BOULDERS];
  }

}

class SoilStructure {
  static const String INTACT = 'Intact';
  static const String FISSURED = 'Fissured';
  static const String SLICKEN_SIDED = 'Slicked-sided'; //[Secondary Soil] with boulders

  static const String SHATTERED = 'Shattered';
  static const String M_SHATTERED = 'Micro-shattered';
  static const String LAMINATED = 'Laminated';
  static const String FOLIATED = 'Foliated';
  static const String STRATIFIED = 'Stratified';

  List<String> getSoilStructure() {
    return [INTACT, FISSURED, SLICKEN_SIDED, SHATTERED, M_SHATTERED, LAMINATED, FOLIATED, STRATIFIED];
  }
}

class TransportedSoilOrigin{
  static const String TALUS = 'Talus';
  static const String HILLWASH = 'Hillwash';
  static const String ALLUVIUM = 'Alluvium'; //[Secondary Soil] with boulders

  static const String LACUSTRINE = 'Lacustrine Depoists';
  static const String ESTUARINE = 'Estuarine Deposits';
  static const String LITTORAL = 'Littoral Deposits';
  static const String AEOLIAN = 'Aeolian Deosits';

  List<String> getTransportedSoil() {
    return [TALUS, HILLWASH, ALLUVIUM, LACUSTRINE, ESTUARINE, LITTORAL, AEOLIAN];
  }
}