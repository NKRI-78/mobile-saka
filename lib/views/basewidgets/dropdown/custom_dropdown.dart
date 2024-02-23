import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class CustomDropDownFormField extends FormField<dynamic> {
  final String titleText;
  final Color titleColor;
  final Color fillColor;
  final String hintText;
  final Color hintTextColor;
  final bool required;
  final String errorText;
  final dynamic value;
  final List? dataSource;
  final String? textField;
  final String? valueField;
  final Function? onChanged;
  final bool filled;

  CustomDropDownFormField({
  Key? key, 
  FormFieldSetter<dynamic>? onSaved,
  FormFieldValidator<dynamic>? validator,
  bool autovalidate = false,
  this.titleText = '',
  this.titleColor = ColorResources.white,
  this.hintText = 'Select one option',
  this.hintTextColor = ColorResources.brown,
  this.required = false,
  this.errorText = 'Please select one option',
  this.value,
  this.dataSource,
  this.textField,
  this.valueField,
  this.onChanged,
  this.filled = true,
  this.fillColor = ColorResources.white,
  })
  : super(key: key, 
    onSaved: onSaved,
    validator: validator,
    autovalidateMode: AutovalidateMode.always,
    initialValue: value == '' ? '' : value,
    builder: (FormFieldState<dynamic> state) {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none
                ),
                filled: filled,
                fillColor: fillColor,
                hintStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: hintTextColor
                )
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  hint: Text(hintText,
                    style: robotoRegular.copyWith(
                      color: Colors.grey,
                      fontSize: Dimensions.fontSizeSmall
                    ),
                  ),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall
                  ),
                  value: value == '' ? '' : value,
                  onChanged: (dynamic newValue) {
                    state.didChange(newValue);
                    onChanged!(newValue);
                  },
                  items: dataSource!.map((item) {
                    return DropdownMenuItem<dynamic>(
                      value: item[valueField],
                      child: Text(item[textField],
                        overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(
                          color: item[textField] == "Select Category" ||  item[textField] == "Pilih Kategori"
                          ? ColorResources.black 
                          : ColorResources.brown,
                          fontSize: Dimensions.fontSizeSmall
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: state.hasError ? 5.0 : 0.0),
            Text(
              state.hasError ? state.errorText! : '',
              style: robotoRegular.copyWith(
                color: Colors.redAccent.shade700,
                fontSize: state.hasError ? 12.0 : 0.0
              ),
            ),
          ],
        ),
      );
    },
  );
}