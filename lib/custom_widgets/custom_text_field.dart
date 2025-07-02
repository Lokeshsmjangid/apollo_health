import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final bool? enabled;
  final int? maxLines;
  final bool? readOnly;
  final bool? obscureText;
  final bool? autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final void Function()? onTap;
  final String obscuringCharacter;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  //Inside decoration
  final bool filled;
  final bool? autofocus;
  final Color? fillColor;
  final Color? hintColor;
  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final String? helperText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({super.key,
    this.onTap,
    this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.enabled = true,
    this.validator,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onChanged,
    this.readOnly = false,
    this.autocorrect = false,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.obscuringCharacter  = '•',
    this.textInputAction,
    // inside decoration
    this.filled = true,
    this.autofocus = false,
    this.fillColor,
    this.hintColor,
    this.border,
    this.contentPadding,
    this.hintText,
    this.helperText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization  = TextCapitalization. none,



  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        /*boxShadow: [ // apolllo
          boxShadowTextField()
        ]*/
      ),
      child: TextFormField(

        onTap: widget.onTap,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly!,
        controller: widget.controller,
        obscureText: widget.obscureText!,
        validator: widget.validator,
        autofocus: widget.autofocus!,
        textCapitalization: widget.textCapitalization,
        autocorrect: widget.autocorrect!,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        onFieldSubmitted: widget.onFieldSubmitted,
        enableSuggestions: widget.enableSuggestions,
        obscuringCharacter: widget.obscuringCharacter,
        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.blackColor,fontFamily: 'Manrope'),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: AppColors.redColor1,),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabled: true,
          errorMaxLines: 5,
          helperText: widget.helperText,
          helperMaxLines: 5,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.hintColor??AppColors.textFieldHintColor,fontWeight: FontWeight.w500,fontFamily: 'Manrope'),
          labelText: widget.labelText,
          filled: widget.filled,
          fillColor: widget.fillColor??AppColors.containerBorderColor.withOpacity(0.1),
          border: widget.border??OutlineInputBorder(borderRadius: BorderRadius.circular(1000)),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          prefixIconConstraints: const BoxConstraints(maxHeight: 44,minWidth: 44),// use because unbalanced height of text area after adding prefix icon
          suffixIconConstraints: const BoxConstraints(maxHeight: 44,minWidth: 44),
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
          focusedBorder: OutlineInputBorder(
            borderSide: widget.readOnly!?const BorderSide(
                color: AppColors.primaryLightColor):const BorderSide(color: AppColors.primaryColor),
            borderRadius:BorderRadius.circular(widget.maxLines! > 1?14 :1000),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:  widget.readOnly!?const BorderSide(
                color: AppColors.primaryColor):const BorderSide(
                color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(widget.maxLines! > 1?14 :1000),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:  const BorderSide(
                color: AppColors.redColor),
            borderRadius: BorderRadius.circular(widget.maxLines! > 1?14 :1000),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:  const BorderSide(
                color: AppColors.redColor),
            borderRadius: BorderRadius.circular(widget.maxLines! > 1?14 :1000),
          ),

        ),
      ),
    );
  }
}
