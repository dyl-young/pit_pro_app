// ignore_for_file: constant_identifier_names

import 'dart:ui';

//packages
import 'package:flutter/material.dart';

//! moisture
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

//! colour
class SoilColour {
  //*colour Strings
  static const String D_BROWN = 'Dark Brown';
  static const String M_BROWN = 'Medium Brown';
  static const String L_BROWN = 'Light Brown';
  static const String D_RED_BROWN = 'Dark Red-Brown';
  static const String L_RED_BROWN = 'Light Red-Brown';

  static const String D_RED = 'Dark Red';
  static const String L_RED = 'Light Red';
  static const String D_RED_ORANGE = 'Dark Red-Orange';
  static const String L_RED_ORANGE = 'Light Red-Orange';
  static const String D_YELLOW_ORANGE = 'Dark Yellow-Orange';
  static const String L_YELLOW_ORANGE = 'Light Yellow-Orange';

  static const String D_YELLOW_BROWN = 'Dark Yellow-Brown';
  static const String L_YELLOW_BROWN = 'Light Yellow-Brown';
  static const String D_YELLOW = 'Dark Yellow';
  static const String L_YELLOW = 'Light Yellow';
  static const String D_ORANGE_BROWN = 'Dark Orange-Brown';
  static const String L_ORANGE_BROWN = 'Light Orange-Brown';
  static const String D_GREEN_BROWN = 'Dark Green-Brown';
  static const String L_GREEN_BROWN = 'Light Green-Brown';
  static const String D_GREY = 'Dark Grey';
  static const String M_GREY = 'Medium Grey';
  static const String L_GREY = 'Light Grey';
  static const String D_GREEN_GREY = 'Dark Green-Grey';
  static const String L_GREEN_GREY = 'Light Green-Grey';
  static const String D_BLUE_GREY = 'Dark Blue-Grey';
  static const String L_BLUE_GREY = 'Light Blue-Grey';
  static const String D_YELLOW_GREY = 'Dark Yellow-Grey';
  static const String L_YELLOW_GREY = 'Light Yellow-Grey';
  static const String D_OLIVE = 'Dark Olive';
  static const String M_OLIVE = 'Medium Olive';
  static const String L_OLIVE = 'Light Olive';

  //*colour values
  static const Color D_BROWN_Value = Color.fromARGB(255, 27, 19, 17);
  static const Color M_BROWN_Value = Color.fromARGB(255, 133, 81, 68);
  static const Color L_BROWN_Value = Color.fromARGB(255, 177, 135, 121);
  static const Color D_RED_BROWN_Value = Color.fromARGB(255, 153, 62, 43);
  static const Color L_RED_BROWN_Value = Color.fromARGB(255, 220, 139, 112);

  static const Color D_RED_Value = Color.fromARGB(255, 152, 69, 64);
  static const Color L_RED_Value = Color.fromARGB(255, 209, 126, 114);
  static const Color D_RED_ORANGE_Value = Color.fromARGB(255, 147, 78, 36);
  static const Color L_RED_ORANGE_Value = Color.fromARGB(255, 204, 126, 88);
  static const Color D_YELLOW_ORANGE_Value = Color.fromARGB(255, 165, 104, 36);
  static const Color L_YELLOW_ORANGE_Value = Color.fromARGB(255, 226, 160, 89);

  static const Color D_YELLOW_BROWN_Value = Color.fromARGB(255, 82, 49, 33);
  static const Color L_YELLOW_BROWN_Value = Color.fromARGB(255, 154, 123, 94);
  static const Color D_YELLOW_Value = Color.fromARGB(255, 182, 136, 46);
  static const Color L_YELLOW_Value = Color.fromARGB(255, 229, 212, 156);
  static const Color D_ORANGE_BROWN_Value = Color.fromARGB(255, 197, 99, 86);
  static const Color L_ORANGE_BROWN_Value = Color.fromARGB(255, 224, 149, 118);
  static const Color D_GREEN_BROWN_Value = Color.fromARGB(255, 138, 105, 72);
  static const Color L_GREEN_BROWN_Value = Color.fromARGB(255, 212, 160, 102);
  static const Color D_GREY_Value = Color.fromARGB(255, 46, 41, 38);
  static const Color M_GREY_Value = Color.fromARGB(255, 109, 100, 95);
  static const Color L_GREY_Value = Color.fromARGB(255, 161, 154, 147);
  static const Color D_GREEN_GREY_Value = Color.fromARGB(255, 135, 114, 83);
  static const Color L_GREEN_GREY_Value = Color.fromARGB(255, 184, 165, 133);
  static const Color D_BLUE_GREY_Value = Color.fromARGB(255, 40, 44, 55);
  static const Color L_BLUE_GREY_Value = Color.fromARGB(255, 110, 114, 117);
  static const Color D_YELLOW_GREY_Value = Color.fromARGB(255, 174, 144, 92);
  static const Color L_YELLOW_GREY_Value = Color.fromARGB(255, 188, 167, 114);
  static const Color D_OLIVE_Value = Color.fromARGB(255, 160, 160, 124);
  static const Color M_OLIVE_Value = Color.fromARGB(255, 132, 134, 95);
  static const Color L_OLIVE_Value = Color.fromARGB(255, 91, 92, 61);

  //*patterns
  static const String SPECKLED = 'Speckled ';
  static const String MOTTLED = 'Mottled ';
  static const String BLOTCHED = 'Blotched ';
  static const String BANDED = 'Banded ';
  static const String STREAKED = 'Streaked ';
  static const String STAINED = 'Stained ';

  List<String> getSoilColour() {
    return [
      D_BROWN,
      M_BROWN,
      L_BROWN,
      D_RED_BROWN,
      L_RED_BROWN,
      D_RED,
      L_RED,
      D_RED_ORANGE,
      L_RED_ORANGE,
      D_YELLOW_ORANGE,
      L_YELLOW_ORANGE,
      D_YELLOW,
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

  List<String> getSoilColourPattern() {
    return [
      '',
      SPECKLED,
      MOTTLED,
      BLOTCHED,
      BANDED,
      STREAKED,
      STAINED,
    ];
  }

  Map<String, Color> colourValues = {
    D_BROWN: D_BROWN_Value,
    M_BROWN: M_BROWN_Value,
    L_BROWN: L_BROWN_Value,
    D_RED_BROWN: D_RED_BROWN_Value,
    L_RED_BROWN: L_RED_BROWN_Value,
    D_RED: D_RED_Value,
    L_RED: L_RED_Value,
    D_RED_ORANGE: D_RED_ORANGE_Value,
    L_RED_ORANGE: L_RED_ORANGE_Value,
    D_YELLOW_ORANGE: D_YELLOW_ORANGE_Value,
    L_YELLOW_ORANGE: L_YELLOW_ORANGE_Value,
    D_YELLOW_BROWN: D_YELLOW_BROWN_Value,
    L_YELLOW_BROWN: L_YELLOW_BROWN_Value,
    D_YELLOW: D_YELLOW_Value,
    L_YELLOW: L_YELLOW_Value,
    D_ORANGE_BROWN: D_ORANGE_BROWN_Value,
    L_ORANGE_BROWN: L_ORANGE_BROWN_Value,
    D_GREEN_BROWN: D_GREEN_BROWN_Value,
    L_GREEN_BROWN: L_GREEN_BROWN_Value,
    D_GREY: D_GREY_Value,
    M_GREY: M_GREY_Value,
    L_GREY: L_GREY_Value,
    D_GREEN_GREY: D_GREEN_GREY_Value,
    L_GREEN_GREY: L_GREEN_GREY_Value,
    D_BLUE_GREY: D_BLUE_GREY_Value,
    L_BLUE_GREY: L_BLUE_GREY_Value,
    D_YELLOW_GREY: D_YELLOW_GREY_Value,
    L_YELLOW_GREY: L_YELLOW_GREY_Value,
    D_OLIVE: D_OLIVE_Value,
    M_OLIVE: M_OLIVE_Value,
    L_OLIVE: L_OLIVE_Value
  };
}

//! Consistency
class SoilConsistency {
  //* Cohesive Consistency
  static const String V_SOFT = 'Very Soft';
  static const String SOFT = 'Soft';
  static const String FIRM = 'Firm';
  static const String STIFF = 'Stiff';
  static const String V_STIFF = 'Very Stiff';

  //* Granular Consistency
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

//! Soil Types
class SoilTypes {
  //* Primary Soil
  static const String ROOTS = 'Roots';
  static const String FILL = 'Fill';
  static const String BOULDERS = 'Boulders'; //[Secondary Soil] with boulders

  static const String GRAVEL = 'Gravel';
  static const String SAND = 'Sand';
  static const String SILT = 'Silt';
  static const String CLAY = 'Clay';

  //* Secondary Soil
  static const String L_BOULDERS =
      'Scattered Boulders'; //Scattered Boulders in [Primary Soil]
  static const String L_GRAVEL = 'Gravelly';
  static const String L_SAND = 'Sandy';
  static const String L_SILT = 'Silty';
  static const String L_CLAY = 'Clayey';

  Map<String, bool> primTypes = {
    GRAVEL: false,
    SAND: false,
    SILT: false,
    CLAY: false,
    ROOTS: false,
    FILL: false,
    BOULDERS: false
  };
  Map<String, bool> secTypes = {
    L_BOULDERS: false,
    L_GRAVEL: false,
    L_SAND: false,
    L_SILT: false,
    L_CLAY: false,
  };

  List<String> getPrimSoilTypes() {
    return [BOULDERS, GRAVEL, SAND, SILT, CLAY, ROOTS, FILL];
  }

  List<String> getSecSoilTypes() {
    return [L_BOULDERS, L_GRAVEL, L_SAND, L_SILT, L_CLAY];
  }
}

//! Structure
class SoilStructure {
  static const String GRANULAR = 'Granular';
  static const String INTACT = 'Intact';
  static const String FISSURED = 'Fissured';
  static const String SLICKENSIDED = 'Slicken-sided';
  static const String SHATTERED = 'Shattered';
  static const String M_SHATTERED = 'Micro-shattered';
  static const String LAMINATED = 'Laminated';
  static const String FOLIATED = 'Foliated';
  static const String STRATIFIED = 'Stratified';
  static const String PINHOLED = 'Pinholed';
  static const String HONEYCOMBED = 'Honeycombed';
  static const String MATRIX_SUPPORTED = 'Matrix-Supported';
  static const String CLAST_SUPPORTED = 'Clast-Supported';

  List<String> getSoilStructure() {
    return [
      GRANULAR,
      INTACT,
      FISSURED,
      SLICKENSIDED,
      SHATTERED,
      M_SHATTERED,
      LAMINATED,
      FOLIATED,
      STRATIFIED,
      PINHOLED,
      HONEYCOMBED,
      MATRIX_SUPPORTED,
      CLAST_SUPPORTED
    ];
  }
}

//! Transported origin
class TransportedSoilOrigin {
  static const String TALUS = 'Talus';
  static const String HILLWASH = 'Hillwash';
  static const String ALLUVIUM = 'Alluvium';
  static const String LACUSTRINE = 'Lacustrine Deposits';
  static const String ESTUARINE = 'Estuarine Deposits';
  static const String LITTORAL = 'Littoral Deposits';
  static const String AEOLIAN = 'Aeolian Deosits';
  static const String MIXED = 'Sandy soils of mixed origin';

  List<String> getTransportedSoil() {
    return [
      TALUS,
      HILLWASH,
      ALLUVIUM,
      LACUSTRINE,
      ESTUARINE,
      LITTORAL,
      AEOLIAN,
      MIXED
    ];
  }
}
