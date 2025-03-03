import 'dart:convert';
import 'package:company_app/model/auth_response.dart';
import 'package:company_app/model/auth_user.dart';
import 'package:company_app/model/recipe.dart';
import 'package:http/http.dart' as http;


Future<AuthResponse?> loginUser(String username, String password) async {
  try {
    final url = Uri.parse('https://dummyjson.com/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<AuthUser?> getCurrentUser(String accessToken) async {
  try {
    final url = Uri.parse('https://dummyjson.com/auth/me');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return AuthUser.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<List<Recipe>?> getRecipe() async {
  try {
    final url = Uri.parse('https://dummyjson.com/recipes');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return (jsonResponse['recipes'] as List)
          .map((recipe) => Recipe.fromJson(recipe))
          .toList();
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<List<Recipe>?> fetchRecipes(String query) async {
  final url = Uri.parse('https://dummyjson.com/recipes/search?q=$query');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      RecipeResponse recipeResponse = RecipeResponse.fromJson(data);
      return recipeResponse.recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  } catch (e) {
    print('Error fetching recipes: $e');
    return null;
  }
}

Future<List<Recipe>?> fetchRecipesByTag(String tag) async {
  final url = Uri.parse('https://dummyjson.com/recipes/tag/$tag');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      RecipeResponse recipeResponse = RecipeResponse.fromJson(data);
      return recipeResponse.recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  } catch (e) {
    print('Error fetching recipes: $e');
    return null;
  }
}
