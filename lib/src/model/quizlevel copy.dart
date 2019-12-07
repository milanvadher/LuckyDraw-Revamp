class QuizLevel {
  int levelIndex;
  String name;
  String levelType;
  int totalQuestions;
  List<Category> category;
  String startDate;
  String endDate;
  String description;
  String imagepath;
  int totalscores;

  QuizLevel(
      {this.levelIndex,
      this.name,
      this.levelType,
      this.totalQuestions,
      this.category,
      this.startDate,
      this.endDate,
      this.description,
      this.imagepath,
      this.totalscores});

  QuizLevel.fromJson(Map<String, dynamic> json) {
    levelIndex = json['level_index'];
    name = json['name'];
    levelType = json['level_type'];
    totalQuestions = json['total_questions'];
    if (json['categorys'] != null) {
      category = new List<Category>();
      json['categorys'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    imagepath = json['imagepath'];
    totalscores = json['totalscores'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level_index'] = this.levelIndex;
    data['name'] = this.name;
    data['level_type'] = this.levelType;
    data['total_questions'] = this.totalQuestions;
    if (this.category != null) {
      data['categorys'] = this.category.map((v) => v.toJson()).toList();
    }
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    data['imagepath'] = this.imagepath;
    data['totalscores'] = this.totalscores;
    return data;
  }

  @override
  String toString() {
    return 'QuizLevel{levelIndex: $levelIndex, name: $name, levelType: $levelType, totalQuestions: $totalQuestions, category: $category, startDate: $startDate, endDate: $endDate, description: $description, imagepath: $imagepath, totalscores: $totalscores}';
  }
}

class Category {
  String sId;
  int categoryNumber;
  String category;

  Category({this.sId, this.categoryNumber, this.category});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryNumber = json['category_number'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category_number'] = this.categoryNumber;
    data['category'] = this.category;
    return data;
  }
}
