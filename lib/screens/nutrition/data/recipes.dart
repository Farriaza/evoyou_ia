class Recipe {

  final String id;

  final String title;

  final String description;

  final String mealType;

  final String goal;

  final int calories;

  final int protein;

  final int carbs;

  final int fat;

  final String time;

  final List<String> ingredients;

  final List<String> steps;

  const Recipe({

    required this.id,

    required this.title,

    required this.description,

    required this.mealType,

    required this.goal,

    required this.calories,

    required this.protein,

    required this.carbs,

    required this.fat,

    required this.time,

    required this.ingredients,

    required this.steps,
  });
}