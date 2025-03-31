import 'package:dependent_multiselect_search_dropdown/dependent_multiselect_search_dropdown.dart'
    show CascadingDropdown, DropdownController, DropdownItem;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExampleDropdownScreen(),
    );
  }
}

class ExampleDropdownScreen extends StatefulWidget {
  const ExampleDropdownScreen({super.key});
  @override
  State<ExampleDropdownScreen> createState() => _ExampleDropdownScreenState();
}

class _ExampleDropdownScreenState extends State<ExampleDropdownScreen> {
  final countryController = DropdownController<String>();
  final stateController = DropdownController<String>();
  final cityController = DropdownController<String>();
  final hospitalController = DropdownController<String>();
  final managerController = DropdownController<String>();

  bool isStateEnabled = false;
  bool isCityEnabled = false;
  bool isHospitalEnabled = false;
  bool isManagerEnabled = false;

  final allCountries = [
    DropdownItem(id: "1", name: "India", value: "India"),
    DropdownItem(id: "2", name: "USA", value: "USA"),
  ];

  final allStates = {
    "1": [
      DropdownItem(id: "1", name: "Gujarat", value: "Gujarat"),
      DropdownItem(id: "2", name: "Maharashtra", value: "Maharashtra"),
    ],
    "2": [
      DropdownItem(id: "3", name: "California", value: "California"),
      DropdownItem(id: "4", name: "Texas", value: "Texas"),
    ],
  };

  final allCities = {
    "1": [
      DropdownItem(id: "1", name: "Ahmedabad", value: "Ahmedabad"),
      DropdownItem(id: "2", name: "Surat", value: "Surat"),
    ],
    "2": [
      DropdownItem(id: "3", name: "Pune", value: "Pune"),
      DropdownItem(id: "4", name: "Mumbai", value: "Mumbai"),
    ],
    "3": [
      DropdownItem(id: "5", name: "Los Angeles", value: "LA"),
      DropdownItem(id: "6", name: "San Diego", value: "San Diego"),
    ],
    "4": [
      DropdownItem(id: "7", name: "Houston", value: "Houston"),
      DropdownItem(id: "8", name: "Dallas", value: "Dallas"),
    ],
  };

  final allHospitals = {
    "1": [
      DropdownItem(id: "1", name: "Apollo Hospital", value: "Apollo"),
      DropdownItem(id: "2", name: "CIMS", value: "CIMS"),
    ],
    "2": [DropdownItem(id: "3", name: "Surat Hospital", value: "SuratHosp")],
    "3": [DropdownItem(id: "4", name: "Ruby Hall", value: "Ruby")],
    "4": [
      DropdownItem(id: "5", name: "Mumbai Central", value: "MumbaiCentral"),
    ],
    "5": [DropdownItem(id: "6", name: "LA Care", value: "LACare")],
    "6": [DropdownItem(id: "7", name: "San Diego Clinic", value: "SDC")],
    "7": [DropdownItem(id: "8", name: "Houston Med", value: "HoustonMed")],
    "8": [DropdownItem(id: "9", name: "Dallas Health", value: "DallasHealth")],
  };

  final allManagers = {
    "1": [
      DropdownItem(id: "1", name: "Dr. Mehta", value: "Mehta"),
      DropdownItem(id: "2", name: "Dr. Patel", value: "Patel"),
    ],
    "2": [
      DropdownItem(id: "3", name: "Dr. Sharma", value: "Sharma"),
      DropdownItem(id: "4", name: "Dr. Jain", value: "Jain"),
    ],
    "4": [DropdownItem(id: "5", name: "Dr. Reddy", value: "Reddy")],
    "6": [
      DropdownItem(id: "6", name: "Dr. Watson", value: "Watson"),
      DropdownItem(id: "7", name: "Dr. Bruce", value: "Bruce"),
    ],
    "8": [DropdownItem(id: "8", name: "Dr. Strange", value: "Strange")],
    "9": [DropdownItem(id: "9", name: "Dr. House", value: "House")],
  };

  @override
  void initState() {
    super.initState();
    countryController.setOptions(List.from(allCountries));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cascading Dropdown Example")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CascadingDropdown<String>(
              controller: countryController,
              hintText: "Select Country",
              searchHint: "Search Country",
              validateHint: "Please select at least one country",
              isMultiSelect: true,
              onItemsChanged: (selected) {
                final states = <DropdownItem<String>>[];
                for (var c in selected) {
                  states.addAll(allStates[c.id] ?? []);
                }
                setState(() {
                  // stateController.setOptions(states);
                  stateController.setOptions([
                    ...states,
                  ]); // Forces rebuild with new list reference
                  stateController.clearSelection();
                  isStateEnabled = selected.isNotEmpty;

                  cityController.clearSelection();
                  cityController.setOptions([]);
                  isCityEnabled = false;

                  hospitalController.clearSelection();
                  hospitalController.setOptions([]);
                  isHospitalEnabled = false;

                  managerController.clearSelection();
                  managerController.setOptions([]);
                  isManagerEnabled = false;
                });
              },
            ),
            const SizedBox(height: 16),
            CascadingDropdown<String>(
              controller: stateController,
              hintText: "Select State",
              searchHint: "Search State",
              validateHint: "Please select a state",
              isMultiSelect: true,
              isEnabled: isStateEnabled,
              onItemsChanged: (selected) {
                final cities = <DropdownItem<String>>[];
                for (var s in selected) {
                  cities.addAll(allCities[s.id] ?? []);
                }
                setState(() {
                  cityController.setOptions(cities);
                  cityController.clearSelection();
                  isCityEnabled = selected.isNotEmpty;

                  hospitalController.clearSelection();
                  hospitalController.setOptions([]);
                  isHospitalEnabled = false;

                  managerController.clearSelection();
                  managerController.setOptions([]);
                  isManagerEnabled = false;
                });
              },
            ),
            const SizedBox(height: 16),
            CascadingDropdown<String>(
              controller: cityController,
              hintText: "Select City",
              searchHint: "Search City",
              validateHint: "Please select a city",
              isMultiSelect: true,
              isEnabled: isCityEnabled,
              onItemsChanged: (selected) {
                final hospitals = <DropdownItem<String>>[];
                for (var c in selected) {
                  hospitals.addAll(allHospitals[c.id] ?? []);
                }
                setState(() {
                  hospitalController.setOptions(hospitals);
                  hospitalController.clearSelection();
                  isHospitalEnabled = selected.isNotEmpty;

                  managerController.clearSelection();
                  managerController.setOptions([]);
                  isManagerEnabled = false;
                });
              },
            ),
            const SizedBox(height: 16),
            CascadingDropdown<String>(
              controller: hospitalController,
              hintText: "Select Hospital",
              searchHint: "Search Hospital",
              validateHint: "Please select a hospital",
              isMultiSelect: true,
              isEnabled: isHospitalEnabled,
              onItemsChanged: (selectedHospitals) {
                setState(() {
                  managerController.clearSelection();
                  managerController.setOptions([]);

                  final List<DropdownItem<String>> managers = [];

                  for (var h in selectedHospitals) {
                    if (h.id == "1" || h.id == "3") {
                      managers.addAll([
                        DropdownItem(
                          id: "1",
                          name: "Dr. Mehta",
                          value: "Mehta",
                        ),
                        DropdownItem(
                          id: "2",
                          name: "Dr. Patel",
                          value: "Patel",
                        ),
                      ]);
                    } else if (h.id == "2" || h.id == "5") {
                      managers.addAll([
                        DropdownItem(
                          id: "3",
                          name: "Dr. Sharma",
                          value: "Sharma",
                        ),
                        DropdownItem(id: "4", name: "Dr. Jain", value: "Jain"),
                      ]);
                    } else if (h.id == "4" || h.id == "6") {
                      managers.addAll([
                        DropdownItem(
                          id: "5",
                          name: "Dr. Reddy",
                          value: "Reddy",
                        ),
                      ]);
                    } else if (h.id == "7") {
                      managers.addAll([
                        DropdownItem(
                          id: "6",
                          name: "Dr. Watson",
                          value: "Watson",
                        ),
                        DropdownItem(
                          id: "7",
                          name: "Dr. Bruce",
                          value: "Bruce",
                        ),
                      ]);
                    } else if (h.id == "8") {
                      managers.addAll([
                        DropdownItem(
                          id: "8",
                          name: "Dr. Strange",
                          value: "Strange",
                        ),
                      ]);
                    } else if (h.id == "9") {
                      managers.addAll([
                        DropdownItem(
                          id: "9",
                          name: "Dr. House",
                          value: "House",
                        ),
                      ]);
                    }
                  }

                  managerController.setOptions(managers);
                  isManagerEnabled = selectedHospitals.isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 16),
            CascadingDropdown<String>(
              controller: managerController,
              hintText: "Select Manager",
              searchHint: "Search Manager",
              validateHint: "Please select at least one manager",
              isMultiSelect: true,
              isEnabled: isManagerEnabled,
              onItemsChanged: (selectedManagers) {
                if (selectedManagers.isEmpty) {
                  setState(() {
                    hospitalController.clearSelection();
                    isManagerEnabled = false;
                    managerController.setOptions([]);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

///run
///flutter run -d chrome --target=example/lib/main.dart
