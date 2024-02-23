import 'package:flutter/material.dart';

import 'package:saka/data/models/category/category.dart';
import 'package:saka/data/repository/category/category.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo cr;

  CategoryProvider({
    required this.cr
  });

  List<Category> _categoryList = [];
  int? _categorySelectedIndex = 0;

  List<Category> get categoryList => _categoryList;

  int get categorySelectedIndex => _categorySelectedIndex!;

  void initCategoryList(BuildContext context) async {
    _categoryList = [];
    cr.getCategoryList(context).forEach((category) => _categoryList.add(category));
    _categorySelectedIndex = 0;
    Future.delayed(Duration.zero,() => notifyListeners());    
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
