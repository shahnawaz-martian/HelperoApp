import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpero/base_widget/location_permission_dialog.dart';
import 'package:helpero/base_widget/show_custom_snakbar_widget.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/view/add_update_address.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../base_widget/dots_flicker_loading.dart';
import '../../../../../../helper/location_controller.dart';
import '../../../../../../helper/location_helper.dart';
import '../../../../../../main.dart';
import '../../../../../widget/custom_textfield.dart';
import '../../../../controllers/address_controller.dart';
import '../../../../domain/models/profile_model.dart';
import '../view/not_serviceable_screen.dart';

class SearchAddress extends StatefulWidget {
  final Addresses? lastSelectedAddress;
  final int? index;
  final bool isFromCreateOrder;
  final bool isFromEditProfile;
  const SearchAddress({
    super.key,
    this.lastSelectedAddress,
    this.index,
    this.isFromCreateOrder = false,
    this.isFromEditProfile = false,
  });

  @override
  State<SearchAddress> createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress>
    with WidgetsBindingObserver {
  final searchController = TextEditingController();
  bool _pendingLocationFetch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressController = context.read<AddressController>();
      addressController.suggestions.clear();
      addressController.notifyListeners();
    });

    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }

  // Listen for app resuming from background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _pendingLocationFetch) {
      _pendingLocationFetch = false;
      final status = await Permission.location.status;
      if (status.isGranted) {
        await context.read<LocationController>().fetchCurrentAddress(
          forceRefresh: true,
        );
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Provider.of<LocationController>(context);
    final addressController = Provider.of<AddressController>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: searchController,
                label: "Search",
                hintText: "Search for area, street name...",
                keyboardType: TextInputType.streetAddress,
                validator: null,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                onChanged: (value) {
                  if (value.length > 2) {
                    addressController.getPlaceSuggestions(value);
                  } else {
                    addressController.suggestions = [];
                  }
                },
              ),
              if (addressController.suggestions.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: addressController.suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = addressController.suggestions[index];
                      return InkWell(
                        onTap: () async {
                          // SHOW FLICKER LOADER
                          showFlickerLoader();
                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (_) => const Material(
                          //     color: Colors.transparent,
                          //     child: DotsFlickerLoading(),
                          //   ),
                          // );

                          try {
                            final place = await addressController
                                .fetchPlaceDetails(suggestion['place_id']);

                            if (place == null) {
                              hideFlickerLoader();
                              return;
                            }

                            final lat = place['latitude'];
                            final lng = place['longitude'];

                            if (lat != null && lng != null) {
                              var isAllowed = await addressController
                                  .isAllowedLocationByLatLng(lat, lng);

                              if (!isAllowed) {
                                hideFlickerLoader();

                                Navigator.push(
                                  Get.context!,
                                  MaterialPageRoute(
                                    builder: (_) => NotServiceableScreen(
                                      area:
                                          place['formattedAddress'] ??
                                          "Selected Location",
                                    ),
                                  ),
                                );
                                return;
                              }
                            }

                            double distance = 0.0;
                            if (lat != null && lng != null) {
                              distance =
                                  await addressController.getDistanceFromOffice(
                                    lat,
                                    lng,
                                  ) ??
                                  0.0;
                            }

                            final selectedAddr = Addresses(
                              addressLine1: place['addressLine1'] ?? '',
                              addressLine2: place['addressLine2'] ?? '',
                              city: place['city'] ?? '',
                              state: place['state'] ?? '',
                              pinCode: place['postalCode'] ?? '',
                              distance: distance,
                              blockNo: '',
                            );

                            addressController.suggestions.clear();
                            searchController.clear();

                            hideFlickerLoader();

                            final newAddress = await Navigator.of(Get.context!)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => AddUpdateAddress(
                                      selectedAddress: selectedAddr,
                                      index: widget.index,
                                      isFromCreateOrder:
                                          widget.isFromCreateOrder,
                                      isFromEditProfile:
                                          widget.isFromEditProfile,
                                    ),
                                  ),
                                );

                            if (newAddress != null) {
                              Navigator.pop(Get.context!, newAddress);
                            } else {
                              if (widget.isFromEditProfile ||
                                  widget.isFromCreateOrder) {
                                Navigator.pop(Get.context!);
                              }
                            }
                          } catch (e) {
                            hideFlickerLoader();
                          }
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 7,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 17),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  suggestion['description'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 1.h),
              //Last Address
              if (widget.lastSelectedAddress != null) ...[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(Get.context!).push(
                      MaterialPageRoute(
                        builder: (_) => AddUpdateAddress(
                          selectedAddress: widget.lastSelectedAddress!,
                          index: widget.index,
                          isFromEditProfile: widget.isFromEditProfile,
                          isFromCreateOrder: widget.isFromEditProfile,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 1.5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Last selected address",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                "${widget.lastSelectedAddress!.addressLine1}, ${widget.lastSelectedAddress!.city}, ${widget.lastSelectedAddress!.state}",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
              ],
              // Use current location
              InkWell(
                onTap: () async {
                  final status = await Permission.location.status;

                  if (status.isGranted) {
                    // Permission already granted
                    await locationController.fetchCurrentAddress(
                      forceRefresh: true,
                    );
                    setState(() {});
                  } else if (status.isDenied) {
                    // First-time denied → native popup
                    final newStatus = await Permission.location.request();
                    if (newStatus.isGranted) {
                      await locationController.fetchCurrentAddress(
                        forceRefresh: true,
                      );
                      setState(() {});
                    } else {
                      // User denied again → do nothing
                      return;
                    }
                  } else if (status.isPermanentlyDenied) {
                    // Permanently denied → show custom dialog
                    final goToSettings = await showDialog<bool>(
                      context: Get.context!,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const LocationPermissionDialog(),
                      ),
                    );

                    if (goToSettings == true) {
                      _pendingLocationFetch = true;
                      await openAppSettings();
                    }

                    return;
                  }

                  showFlickerLoader();
                  try {
                    final locationController = Provider.of<LocationController>(
                      Get.context!,
                      listen: false,
                    );

                    final details = await locationController
                        .getCurrentLocationDetails();

                    if (details == null) {
                      showCustomSnackBar(
                        "Failed to fetch location",
                        Get.context!,
                      );
                      return;
                    }

                    final lat = details['latitude'];
                    final lng = details['longitude'];

                    if (lat != null && lng != null) {
                      var allowed = await addressController
                          .isAllowedLocationByLatLng(lat, lng);

                      if (!allowed) {
                        Navigator.push(
                          Get.context!,
                          MaterialPageRoute(
                            builder: (_) => NotServiceableScreen(
                              area:
                                  details['formattedAddress'] ??
                                  "Current Location",
                            ),
                          ),
                        );
                        return;
                      }
                    }

                    double distance = 0.0;
                    if (lat != null && lng != null) {
                      distance =
                          await addressController.getDistanceFromOffice(
                            lat,
                            lng,
                          ) ??
                          0.0;
                    }

                    final selectedAddr = Addresses(
                      addressLine1: details['addressLine1'] ?? '',
                      addressLine2: details['addressLine2'] ?? '',
                      city: details['city'] ?? '',
                      state: details['state'] ?? '',
                      pinCode: details['postalCode'] ?? '',
                      distance: distance,
                      blockNo: '',
                    );

                    hideFlickerLoader();

                    Navigator.of(Get.context!).pop();
                    final newAddress = await Navigator.of(Get.context!).push(
                      MaterialPageRoute(
                        builder: (_) => AddUpdateAddress(
                          selectedAddress: selectedAddr,
                          index: widget.index,
                          isFromCreateOrder: widget.isFromCreateOrder,
                          isFromEditProfile: widget.isFromEditProfile,
                        ),
                      ),
                    );

                    if (newAddress != null) {
                      Navigator.pop(Get.context!, newAddress);
                    } else {
                      if (widget.isFromEditProfile ||
                          widget.isFromCreateOrder) {
                        Navigator.pop(Get.context!);
                      }
                    }
                  } catch (e) {
                    hideFlickerLoader();
                  }
                },

                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 1.5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Use current location",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              locationController.currentAddress ??
                                  "Fetching...",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFlickerLoader() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) =>
          const Material(color: Colors.black54, child: DotsFlickerLoading()),
    );
  }

  void hideFlickerLoader() {
    Navigator.pop(Get.context!);
  }
}
