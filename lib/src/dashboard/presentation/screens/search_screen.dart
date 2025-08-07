import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';
import 'package:hydro_iot/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String path = 'search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      children: [
        const SizedBox(height: 20),
        SearchBar(
          hintText: 'Search devices...',
          leading: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: const Icon(Icons.search),
          ),
          autoFocus: true,
          keyboardType: TextInputType.text,
          controller: searchController,
          onChanged: (value) {
            // Handle search logic here
          },
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
            if (searchController.text.isEmpty) {
              context.pop();
            }
          },
          backgroundColor: WidgetStateColor.fromMap({
            WidgetState.any: ColorValues.neutral200,
            WidgetState.focused: ColorValues.neutral100,
            WidgetState.hovered: ColorValues.neutral300,
          }),
        ),
        const SizedBox(height: 20),
        // Display search results here
      ],
    );
  }
}
