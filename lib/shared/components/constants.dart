// GET

//newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=56d1f222b0cd45e6877b520a55925379

//Remember restaurant analogy
// base url : https://newsapi.org
// method(url) : /v2/top-headlines? -- table and columns
// queries : country=eg&category=business&apiKey=56d1f222b0cd45e6877b520a55925379

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_reminder/models/task_model.dart';

import '../network/local/cache_helper.dart';
import 'components.dart';

String? token = '';
String? uId = '';
int? likeCount = 0;
int? dislikeCount = 0;

List<TaskModel> tasks = [];
List<TaskModel> doneTasks = [];
List<TaskModel> selectedTasks = [];
bool isCategoryClicked = false;
bool isDatePassed = false;
bool isCategorySelected = false;
bool isRepeated = false;
List<int> dayNumbers = [];

List<dynamic>? defaultCategories = [
  'تذكيرات العمل',
  'تذكيرات الدراسة',
  'تذكيرات العبادة',
  'تذكيرات التسوق'
];
List<dynamic>? categoriesList = [];
dynamic newCategory;
dynamic newUpdatedCategory;
bool isCategoriesListChanged = false;
