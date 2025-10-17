
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownButton2<T> extends StatelessWidget {
  final String hintText;
  final String searchHintText;
  final List<T> items;
  final T? value;
  final String Function(T)? displayText;
  final void Function(T?)? onChanged;
  final TextEditingController? searchController;
  final void Function()? onTap; // to change icon
  final String? icon; // to change icon

  const CustomDropdownButton2({
    Key? key,
    required this.hintText,
    this.searchHintText='',
    required this.items,
    required this.value,
    required this.displayText,
    required this.onChanged,
    this.searchController,
    this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: addText500(hintText,color: AppColors.textFieldHintColor,fontFamily: 'Manrope'),
        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.blackColor,fontFamily: 'Manrope'),
        items: items.map((item) => DropdownMenuItem<T>(
          value: item,
          onTap: onTap,
          child: addText500(
            displayText!(item) ?? '', fontSize: 16,
          ),
        )).toList(),
        value: value,
        onChanged: onChanged,
        iconStyleData: IconStyleData(icon: (icon != null && icon!.isNotEmpty)
            ? SvgPicture.asset('$icon', width: 8, height: 8, color: AppColors.blackColor) : SizedBox.shrink()),
        menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.all(16),
            height: 50),
        buttonStyleData: ButtonStyleData(
          height: 54,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(
              color: AppColors.primaryColor,
            ),
            // boxShadow: [boxShadowTextField()],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          // isFullScreen: true,
          offset: Offset(0, -5),
          maxHeight: 200,
          scrollbarTheme: ScrollbarThemeData(

            radius: const Radius.circular(40),
            // thickness: MaterialStateProperty.all(2),
            // thumbColor: MaterialStateProperty.all(AppColors.primaryColor),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(32), // border change for dialogue
            color: AppColors.whiteColor,
          ),
        ),
        dropdownSearchData: searchController != null
            ? DropdownSearchData<T>(
          searchController: searchController!,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: searchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: searchHintText,
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return displayText!(item.value as T).toLowerCase().contains(searchValue.toLowerCase());
          },
        )
            : null,
        // This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen && searchController != null) {
            searchController!.clear();
          }
        },
      ),
    );
  }
}
