import 'dart:convert';
import '../model/auth_response.dart';
import '../model/auth_user.dart';
import '../model/recipe.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json'
  };

  // Auth related methods
  Future<AuthResponse?> loginUser(String username, String password) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: _jsonHeaders,
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
      print('Login error: $e');
      return null;
    }
  }

  Future<AuthUser?> getCurrentUser(String accessToken) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/me');
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
      print('Get current user error: $e');
      return null;
    }
  }

  // Recipe related methods
  Future<List<Recipe>?> getAllRecipes() async {
    try {
      final url = Uri.parse('$_baseUrl/recipes');
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
      print('Get all recipes error: $e');
      return null;
    }
  }

  Future<List<Recipe>?> searchRecipes(String query) async {
    try {
      final url = Uri.parse('$_baseUrl/recipes/search?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        RecipeResponse recipeResponse = RecipeResponse.fromJson(data);
        return recipeResponse.recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Search recipes error: $e');
      return null;
    }
  }

  Future<List<Recipe>?> getRecipesByTag(String tag) async {
    try {
      final url = Uri.parse('$_baseUrl/recipes/tag/$tag');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        RecipeResponse recipeResponse = RecipeResponse.fromJson(data);
        return recipeResponse.recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Get recipes by tag error: $e');
      return null;
    }
  }
}
