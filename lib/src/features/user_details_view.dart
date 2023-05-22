import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/breakpoints.dart';
import 'package:flutter_tindeq/src/localization/string_hardcoded.dart';

/// Displays detailed information about a SampleItem.
class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: Size.fromHeight(80.0),
      //     child: AppBarWidget(title: "User Details")),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRailWidget(),
            VerticalDivider(thickness: 2, width: 1),
            UserDetails(),
          ],
        ),
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController gripTypeController = TextEditingController();
  double currentRedPointSliderValue = 20;
  double currentWeightSliderValue = 70;
  double currentEdgeSizeSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<GripTypeLabel>> gripTypeEntries =
        <DropdownMenuEntry<GripTypeLabel>>[];
    for (final GripTypeLabel color in GripTypeLabel.values) {
      gripTypeEntries.add(
        DropdownMenuEntry<GripTypeLabel>(
            value: color, label: color.label, enabled: color.label != 'Grey'),
      );
    }

    return Container(
      width: Breakpoint.tablet,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           TextField(
            decoration: InputDecoration(
              labelText: 'User Name'.hardcoded,
              border: const OutlineInputBorder(),
            ),
          ),
          Column(
            children: [
              Text(
                  'Weight: ${currentWeightSliderValue.round().toInt().toString()}kg'.hardcoded),
              Slider(
                  value: currentWeightSliderValue,
                  min: 40,
                  max: 100,
                  divisions: 60,
                  label: currentWeightSliderValue.round().toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      currentWeightSliderValue = value;
                    });
                  }),
            ],
          ),
          Column(
            children: [
              Text(
                  'Red Point Grade: ${currentRedPointSliderValue.round().toInt().toString()}'.hardcoded),
              Slider(
                  value: currentRedPointSliderValue,
                  min: 3,
                  max: 39,
                  divisions: 36,
                  label: currentRedPointSliderValue.round().toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      currentRedPointSliderValue = value;
                    });
                  }),
            ],
          ),
          // const Text('Grip Type: '),
          DropdownMenu<GripTypeLabel>(
            initialSelection: GripTypeLabel.halfCrimp,
            controller: gripTypeController,
            label:  Text('Grip Type'.hardcoded),
            dropdownMenuEntries: gripTypeEntries,
            onSelected: (GripTypeLabel? color) {
              setState(() {
                // selectedGripType = label;
              });
            },
          ),
          Column(
            children: [
              Text(
                  'Edge Size: ${currentEdgeSizeSliderValue.round().toInt().toString()}mm'.hardcoded),
              Slider(
                  value: currentEdgeSizeSliderValue,
                  min: 10,
                  max: 30,
                  divisions: 20,
                  label: currentEdgeSizeSliderValue.round().toInt().toString(),
                  onChanged: (value) {
                    debugPrint("setState");
                    setState(() {
                      currentEdgeSizeSliderValue = value;
                    });
                  }),
            ],
          ),
           TextField(
            minLines: 10,
            maxLines: 20,
            decoration: InputDecoration(
              labelText: 'Notes'.hardcoded,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
//TODO enum localization
enum GripTypeLabel {
  halfCrimp('Half Crimp'),
  threeFingerDrag('3 Finger Drag'),
  lockOff('Lock Off');

  const GripTypeLabel(this.label);
  final String label;
}
