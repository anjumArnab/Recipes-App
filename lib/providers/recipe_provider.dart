import 'package:flutter/material.dart';
import '../model/recipe.dart';
import '../services/api_services.dart';

enum RecipeState { initial, loading, loaded, error }

class RecipeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  RecipeState _state = RecipeState.initial;
  List<Recipe> _recipes = [];
  List<Recipe> _searchResults = [];
  List<Recipe> _taggedRecipes = [];
  String? _errorMessage;
  String _currentSearchQuery = '';
  String _currentTag = '';

  // Getters
  RecipeState get state => _state;
  List<Recipe> get recipes => _recipes;
  List<Recipe> get searchResults => _searchResults;
  List<Recipe> get taggedRecipes => _taggedRecipes;
  String? get errorMessage => _errorMessage;
  String get currentSearchQuery => _currentSearchQuery;
  String get currentTag => _currentTag;
  bool get isLoading => _state == RecipeState.loading;
  bool get hasError => _state == RecipeState.error;
  bool get isEmpty => _recipes.isEmpty && _state == RecipeState.loaded;

  // Load all recipes
  Future<void> loadAllRecipes() async {
    _setState(RecipeState.loading);
    _clearError();

    try {
      final recipes = await _apiService.getAllRecipes();

      if (recipes != null) {
        _recipes = recipes;
        _setState(RecipeState.loaded);
      } else {
        _setError('Failed to load recipes');
        _setState(RecipeState.error);
      }
    } catch (e) {
      _setError('Error loading recipes: $e');
      _setState(RecipeState.error);
    }
  }

  // Search recipes
  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      _currentSearchQuery = '';
      notifyListeners();
      return;
    }

    _setState(RecipeState.loading);
    _clearError();
    _currentSearchQuery = query;

    try {
      final recipes = await _apiService.searchRecipes(query);

      if (recipes != null) {
        _searchResults = recipes;
        _setState(RecipeState.loaded);
      } else {
        _setError('No recipes found for "$query"');
        _searchResults.clear();
        _setState(RecipeState.error);
      }
    } catch (e) {
      _setError('Error searching recipes: $e');
      _setState(RecipeState.error);
    }
  }

  // Get recipes by tag
  Future<void> getRecipesByTag(String tag) async {
    if (tag.trim().isEmpty) {
      _taggedRecipes.clear();
      _currentTag = '';
      notifyListeners();
      return;
    }

    _setState(RecipeState.loading);
    _clearError();
    _currentTag = tag;

    try {
      final recipes = await _apiService.getRecipesByTag(tag);

      if (recipes != null) {
        _taggedRecipes = recipes;
        _setState(RecipeState.loaded);
      } else {
        _setError('No recipes found for tag "$tag"');
        _taggedRecipes.clear();
        _setState(RecipeState.error);
      }
    } catch (e) {
      _setError('Error getting recipes by tag: $e');
      _setState(RecipeState.error);
    }
  }

  // Clear search results
  void clearSearch() {
    _searchResults.clear();
    _currentSearchQuery = '';
    notifyListeners();
  }

  // Clear tagged recipes
  void clearTaggedRecipes() {
    _taggedRecipes.clear();
    _currentTag = '';
    notifyListeners();
  }

  // Refresh recipes
  Future<void> refresh() async {
    await loadAllRecipes();
  }

  // Get recipe by ID from loaded recipes
  Recipe? getRecipeById(int id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get favorite recipes (if you have a favorite system)
  List<Recipe> getFavoriteRecipes(List<int> favoriteIds) {
    return _recipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();
  }

  // Get recipes by cuisine type
  List<Recipe> getRecipesByCuisine(String cuisine) {
    return _recipes
        .where(
            (recipe) => recipe.cuisine.toLowerCase() == cuisine.toLowerCase())
        .toList();
  }

  // Get recipes by difficulty level
  List<Recipe> getRecipesByDifficulty(String difficulty) {
    return _recipes
        .where((recipe) =>
            recipe.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }

  // Get recipes within prep time range
  List<Recipe> getRecipesByPrepTime(int maxPrepTime) {
    return _recipes
        .where((recipe) => recipe.prepTimeMinutes <= maxPrepTime)
        .toList();
  }

  void _setState(RecipeState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
