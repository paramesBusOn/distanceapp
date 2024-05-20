// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:googledistanceapp/Map.dart';
// import 'package:googledistanceapp/Widgets/LocationTrack.dart';

// class BelilaAddressAddScreen extends StatefulWidget {
//   const BelilaAddressAddScreen({Key? key}) : super(key: key);

//   @override
//   _BelilaAddressAddScreenState createState() => _BelilaAddressAddScreenState();
// }

// class _BelilaAddressAddScreenState extends State<BelilaAddressAddScreen> {
//   final _formKey = GlobalKey<FormState>();
//   int _initialIndex = 0;
//   PageController? _pageController;

//   late TextEditingController _fullNameController;
//   late TextEditingController _mobileNumberController;
//   late TextEditingController _addressController;
//   late TextEditingController _regionController;
//   late TextEditingController _cityController;
//   late TextEditingController _districtController;
//   late TextEditingController _villageController;
//   late TextEditingController _zipCodeController;

//   bool _isLoading = false;

//   // List<JneRegionModel> _jneRegionList = [];
//   // JneRegionModel? _selectedRegion;
//   // JneRegionModel? _selectedCity;
//   // JneRegionModel? _selectedDistrict;
//   // JneRegionModel? _selectedVillage;
//   double _latitude = 0;
//   double _longitude = 0;

//   GoogleMapController? mapController;
//   List<Placemark> _listAddress = [];
//   // late Position _currentPosition;
//   Set<Marker> _currentMarker = {};

//   Future<void> _onMapCreated(GoogleMapController controller) async {
//     mapController = controller;
//     await _getMyPosition();
//   }

//   void _onMapTapped(LatLng latLang) {
//     // _selectedRegion = null;
//     // _selectedCity = null;
//     // _selectedDistrict = null;
//     // _selectedVillage = null;
//     final _position = Position(
//         longitude: latLang.longitude,
//         latitude: latLang.latitude,
//         timestamp: DateTime.now(),
//         accuracy: 0,
//         altitude: 0,
//         heading: 0,
//         speed: 0,
//         speedAccuracy: 0,
//         altitudeAccuracy: 0.0,
//         headingAccuracy: 0.0);
//     _setStateMarkerAndAddressAndCameraFromPosition(_position);
//   }

//   Future<Position> _getMyPosition() async {
//     final position = await LocationUtils.getCurrentPosition();
//     await _setStateMarkerAndAddressAndCameraFromPosition(position);
//     return position;
//   }

//   Future<void> _setStateMarkerAndAddressAndCameraFromPosition(
//       Position position) async {
//     final _addresses = await _getListAddresFromPosition(position);
//     // place mark(addres) paling dekat dengan marker di index [0]
//     final _address = _addresses[0];
//     setState(() {
//       // _currentPosition = position;
//       _listAddress = _addresses;

//       // if (_selectedRegion != null) {
//       // }
//       // _selectedRegion = _resJneRegionList.map((e) => e.name).firstWhere(
//       //     (element) => element
//       //         .toLowerCase()
//       //         .contains(_listAddress.first.administrativeArea ?? 'xxxx'));
//       _addressController.text = _listAddress.first.street ?? '';
//       _regionController.text = _listAddress.first.administrativeArea ?? '';
//       _cityController.text = _listAddress.first.locality ?? '';
//       _districtController.text = _listAddress.first.subAdministrativeArea ?? '';
//       _villageController.text = _listAddress.first.locality ?? '';
//       _zipCodeController.text = _listAddress.first.postalCode ?? '';
//       _latitude = position.latitude;
//       _longitude = position.longitude;

//       _currentMarker = {
//         Marker(
//           draggable: true,
//           markerId: const MarkerId('Current Position'),
//           position: LatLng(position.latitude, position.longitude),
//           infoWindow: InfoWindow(
//             title: _address.subLocality,
//             snippet:
//                 // ignore: lines_longer_than_80_chars
//                 '${_address.locality}, ${_address.subAdministrativeArea}, ${_address.country}',
//           ),
//         )
//       };
//       mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(position.latitude, position.longitude),
//             zoom: 18,
//           ),
//         ),
//       );
//     });
//   }

//   Future<List<Placemark>> _getListAddresFromPosition(Position position) async {
//     final addresses = await LocationUtils.getListAddressFromPosition(position);
//     return addresses;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _initialIndex);
//     _fullNameController = TextEditingController();
//     _mobileNumberController = TextEditingController();
//     _addressController = TextEditingController();
//     _regionController = TextEditingController();
//     _cityController = TextEditingController();
//     _districtController = TextEditingController();
//     _villageController = TextEditingController();
//     _zipCodeController = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);

//     return Scaffold(
//         appBar: AppBar(
//           title: Text('map'),
//         ),
//         body: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: Column(
//             children: [
//               Expanded(
//                 child: PageView(
//                   controller: _pageController,
//                   physics: const NeverScrollableScrollPhysics(),
//                   onPageChanged: (v) {
//                     setState(() => _initialIndex = v);
//                   },
//                   children: [
//                     BuildAddressMap(
//                       addressController: _addressController, //
//                       cityController: _cityController, //
//                       districtController: _districtController, //
//                       regionController: _regionController, //
//                       villageController: _villageController, //
//                       zipCodeController: _zipCodeController, //
//                       currentMarker: _currentMarker, //
//                       onMapCreated: _onMapCreated, //
//                       onMapTaped: _onMapTapped, //
//                       // Region Dropdown Constructor
//                       latitude: _latitude, //
//                       longitude: _longitude, //
//                       isLoading: _isLoading, //
//                       onTap: () {
//                         setState(() {
//                           _isLoading = true;
//                         });
//                         Future.delayed(const Duration(seconds: 2), () {
//                           // Get.offNamed<dynamic>(BelilaRoutes.address);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
