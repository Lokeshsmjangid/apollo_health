

import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownWithImageButton<T> extends StatelessWidget {
  final String hintText;
  final String searchHintText;
  final List<T> items;
  final T? value;
  final String Function(T)? displayText;
  final String Function(T)? displayImage;
  final void Function(T?)? onChanged;
  final TextEditingController? searchController;

  const CustomDropdownWithImageButton({
    Key? key,
    required this.hintText,
    this.searchHintText='',
    required this.items,
    required this.value,
    required this.displayText,
    required this.onChanged,
    this.searchController, required this.displayImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: addText400(hintText,color: AppColors.textFieldHintColor,fontSize: 14),
        items: items.map((item) => DropdownMenuItem<T>(
          value: item,
          child: Row(
            children: [
              Text(
                displayText!(item) ?? '',
                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.textColor),
              ),
              if(displayImage!=null)
                Image.asset(displayImage!(item),width: 60,height: 20,).marginOnly(left: 14)
            ],
          ),
        )).toList(),
        value: value,
        onChanged: onChanged,
        // iconStyleData: IconStyleData( // apollo
        //     icon: Image.asset(AppAssets.dropDownArrow,width: 16,height: 16,color: AppColors.blackColor,)),
        menuItemStyleData: const MenuItemStyleData(height: 40),
        buttonStyleData: ButtonStyleData(
          height: 48,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(
              color: AppColors.containerBorderColor,
            ),
            // boxShadow: [boxShadowTextField()], // apollo
            // color: AppColors.whiteColor,
          ),
        ),
        dropdownStyleData: DropdownStyleData(

          maxHeight: 250,
          // width: 200,
          // width: MediaQuery.of(context).size.width*0.94,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
