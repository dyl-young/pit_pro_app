//packages
import 'package:location/location.dart';

class LocationServices {
  late final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _grantedPermission;

  Future<bool> _checkService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (_serviceEnabled == false) {
      _serviceEnabled = await _location.requestService();
    }
    return _serviceEnabled;
  }

  Future<bool> _checkPermission() async {
    if (await _checkService() == true) {
      _grantedPermission = await _location.hasPermission();
      if (_grantedPermission == PermissionStatus.denied) {
        _grantedPermission = await _location.requestPermission();
      }
    }
    return _grantedPermission == PermissionStatus.granted;
  }

  Future<LocationData?> getLocation() async {
    late final Future<LocationData>? locationData;
    await _checkPermission()
        ? locationData = _location.getLocation()
        : locationData = null;
    return locationData;
  }
}
