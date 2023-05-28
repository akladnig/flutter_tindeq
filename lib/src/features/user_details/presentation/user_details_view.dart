import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/breakpoints.dart';
import 'package:flutter_tindeq/src/features/user_details/repository/user.dart';
import 'package:flutter_tindeq/src/localization/string_hardcoded.dart';

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

class UserDetails extends ConsumerStatefulWidget {
  const UserDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> {
  final TextEditingController gripTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<GripType>> gripTypeEntries =
        <DropdownMenuEntry<GripType>>[];
    for (final GripType color in GripType.values) {
      gripTypeEntries.add(
        DropdownMenuEntry<GripType>(
            value: color, label: color.label, enabled: color.label != 'Grey'),
      );
    }
    // Watch for user changes
    User user = ref.watch(userProvider);

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
            onChanged: (value) {
              ref.read(userProvider).userName = value;
              setState(() {});
            },
          ),
          Column(
            children: [
              Text('Weight: ${user.weight.round().toInt().toString()}kg'
                  .hardcoded),
              Slider(
                  value: user.weight,
                  min: 40,
                  max: 100,
                  divisions: 60,
                  label: user.weight.round().toInt().toString(),
                  onChanged: (value) {
                    ref.read(userProvider).weight = value;
                    setState(() {});
                  }),
            ],
          ),
          Column(
            children: [
              Text(
                  'Red Point Grade: ${user.redPointGrade.round().toInt().toString()}'
                      .hardcoded),
              Slider(
                  value: user.redPointGrade.toDouble(),
                  min: 3,
                  max: 39,
                  divisions: 36,
                  label: user.redPointGrade.round().toInt().toString(),
                  onChanged: (value) {
                    ref.read(userProvider).redPointGrade = value.toInt();
                    setState(() {});
                  }),
            ],
          ),
          // const Text('Grip Type: '),
          DropdownMenu<GripType>(
            initialSelection: GripType.halfCrimp,
            // controller: gripTypeController,
            label: Text('Grip Type'.hardcoded),
            dropdownMenuEntries: gripTypeEntries,
            onSelected: (value) {
              ref.read(userProvider).gripType = value!;
              setState(() {});
            },
          ),
          Column(
            children: [
              Text('Edge Size: ${user.edgeSize.round().toInt().toString()}mm'
                  .hardcoded),
              Slider(
                  value: user.edgeSize.toDouble(),
                  min: 10,
                  max: 30,
                  divisions: 20,
                  label: user.edgeSize.round().toInt().toString(),
                  onChanged: (value) {
                    ref.read(userProvider).edgeSize = value.toInt();
                    setState(() {});
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
            onChanged: (value) {
              ref.read(userProvider).notes = value;
              setState(() {});
            },
          ),
          Column(
            children: [
              Text("User Name: ${user.userName}"),
              Text("Weight: ${user.weight}"),
              Text("Redpoint Grade: ${user.redPointGrade}"),
              Text("Grip Type: ${user.gripType.label}"),
              Text("Edge Size: ${user.edgeSize}"),
              Text("Notes: ${user.notes}"),
            ],
          )
        ],
      ),
    );
  }
}
