import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googledistanceapp/Constant/Screen.dart';
import 'package:googledistanceapp/Widgets/CustomerElevationButton.dart';
import 'package:googledistanceapp/Widgets/CustomerTextField.dart';

class BuildAddressMap extends StatelessWidget {
  final MapCreatedCallback? onMapCreated;
  final ArgumentCallback<LatLng>? onMapTaped;
  final Set<Marker> currentMarker;
  final TextEditingController addressController;
  final TextEditingController regionController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController villageController;
  final TextEditingController zipCodeController;
  final double? latitude;
  final double? longitude;
  final bool isLoading;
  final VoidCallback onTap;

  const BuildAddressMap({
    Key? key,
    this.onMapCreated,
    this.onMapTaped,
    required this.currentMarker,
    required this.addressController,
    required this.regionController,
    required this.cityController,
    required this.districtController,
    required this.villageController,
    required this.zipCodeController,
    this.latitude,
    this.longitude,
    this.isLoading = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          // height: Screens.bodyheight(context)*0,
          child: GoogleMap(
                                              mapType: MapType.normal,
        
            onMapCreated: onMapCreated,
            onTap: onMapTaped,
            // scrollGesturesEnabled: true,
            // zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude ?? 0.0, longitude ?? 0.0),
              zoom: 2,
            ),
            markers: currentMarker,
          ),
        ),
        Positioned(
          child: DraggableScrollableSheet(
            initialChildSize: .3,
            minChildSize: .2,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: _theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 50,
                          height: 3,
                          decoration: BoxDecoration(
                            color: _theme.hintColor,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'current_address',
                        style: _theme.textTheme.headline3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'address',
                        style: _theme.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: addressController,
                        hintText: 'address',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'province',
                        style: _theme.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: regionController,
                        hintText: 'province',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'city',
                        style: _theme.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: cityController,
                        hintText: 'city',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'district',
                        style: _theme.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: districtController,
                        hintText: 'district',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'village',
                        style: _theme.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: villageController,
                        hintText: 'village',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'zip_code',
                        style: _theme.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: zipCodeController,
                        // textFieldType: TextFieldType.number,
                        hintText: 'zip_code',
                      ),
                      const SizedBox(height: 10),
                      CustomElevatedButton(
                        isLoading: isLoading,
                        onTap: onTap,
                        label: 'save',
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
