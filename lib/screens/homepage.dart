import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/recipe_modal_sheet.dart';
import '../model/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/custom_drawer.dart';
import '../providers/recipe_provider.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> categories = [
    {'icon': '🍕', 'label': 'Italian'},
    {'icon': '🥡', 'label': 'Asian'},
    {'icon': '🍔', 'label': 'American'},
    {'icon': '🌮', 'label': 'Mexican'},
    {'icon': '🥙', 'label': 'Mediterranean'},
    {'icon': '🍛', 'label': 'Pakistani'},
    {'icon': '🍣', 'label': 'Japanese'},
    {'icon': '🍲', 'label': 'Moroccan'},
    {'icon': '🥢', 'label': 'Korean'},
    {'icon': '🥗', 'label': 'Greek'},
    {'icon': '🍜', 'label': 'Thai'},
    {'icon': '🍛', 'label': 'Indian'},
    {'icon': '🍢', 'label': 'Turkish'},
    {'icon': '🍹', 'label': 'Smoothie'},
    {'icon': '🥟', 'label': 'Russian'},
    {'icon': '🥙', 'label': 'Lebanese'},
    {'icon': '🥩', 'label': 'Brazilian'},
  ];

  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showCategories = true;

  @override
  void initState() {
    super.initState();

    // Load recipes when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadAllRecipes();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 10) {
        if (!_showCategories) {
          setState(() {
            _showCategories = true;
          });
        }
      } else {
        if (_showCategories) {
          setState(() {
            _showCategories = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      context.read<RecipeProvider>().searchRecipes(value);
    } else {
      context.read<RecipeProvider>().clearSearch();
      context.read<RecipeProvider>().loadAllRecipes();
    }
  }

  void _onCategoryTapped(String category) {
    context.read<RecipeProvider>().getRecipesByTag(category);
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Text(
                "Welcome ${authProvider.currentUser?.firstName ?? 'User'}");
          },
        ),
      ),
      drawer: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return CustomDrawer(user: authProvider.currentUser!);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: 'Cravings for...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context.read<RecipeProvider>().clearSearch();
                          context.read<RecipeProvider>().loadAllRecipes();
                        },
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 5),
            Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                // Show categories only when not searching or filtering by tag
                bool showCats = _showCategories &&
                    recipeProvider.currentSearchQuery.isEmpty &&
                    recipeProvider.currentTag.isEmpty;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: showCats ? 100 : 0,
                  child: showCats
                      ? SizedBox(
                          height: 80,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: categories.map((category) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: GestureDetector(
                                    onTap: () =>
                                        _onCategoryTapped(category['label']!),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          category['icon']!,
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          category['label']!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
            const SizedBox(height: 5),
            // Show current filter status
            Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                if (recipeProvider.currentSearchQuery.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Search results for: "${recipeProvider.currentSearchQuery}"',
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            searchController.clear();
                            recipeProvider.clearSearch();
                            recipeProvider.loadAllRecipes();
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                } else if (recipeProvider.currentTag.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Showing: ${recipeProvider.currentTag} recipes',
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            recipeProvider.clearTaggedRecipes();
                            recipeProvider.loadAllRecipes();
                          },
                          child: const Text(
                            'Show All',
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: RecipesList(scrollController: _scrollController),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipesList extends StatelessWidget {
  final ScrollController scrollController;

  const RecipesList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        if (recipeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (recipeProvider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  recipeProvider.errorMessage ?? 'Something went wrong',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (recipeProvider.currentSearchQuery.isNotEmpty) {
                      recipeProvider
                          .searchRecipes(recipeProvider.currentSearchQuery);
                    } else if (recipeProvider.currentTag.isNotEmpty) {
                      recipeProvider.getRecipesByTag(recipeProvider.currentTag);
                    } else {
                      recipeProvider.loadAllRecipes();
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Determine which recipes to display
        List<Recipe> displayRecipes = [];
        if (recipeProvider.currentSearchQuery.isNotEmpty) {
          displayRecipes = recipeProvider.searchResults;
        } else if (recipeProvider.currentTag.isNotEmpty) {
          displayRecipes = recipeProvider.taggedRecipes;
        } else {
          displayRecipes = recipeProvider.recipes;
        }

        if (displayRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  recipeProvider.currentSearchQuery.isNotEmpty
                      ? 'No recipes found for "${recipeProvider.currentSearchQuery}"'
                      : recipeProvider.currentTag.isNotEmpty
                          ? 'No recipes found for ${recipeProvider.currentTag}'
                          : 'No recipes available',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (recipeProvider.currentSearchQuery.isNotEmpty) {
              await recipeProvider
                  .searchRecipes(recipeProvider.currentSearchQuery);
            } else if (recipeProvider.currentTag.isNotEmpty) {
              await recipeProvider.getRecipesByTag(recipeProvider.currentTag);
            } else {
              await recipeProvider.refresh();
            }
          },
          child: RecipeGrid(
            recipes: displayRecipes,
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final ScrollController scrollController;

  const RecipeGrid({
    super.key,
    required this.recipes,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 1.4,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Transform.scale(
            scale: 1.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeModalSheet(recipe: recipe),
                  ),
                );
              },
              child: RecipeCard(
                image: recipe.image,
                name: recipe.name,
                cuisine: recipe.cuisine,
                difficulty: recipe.difficulty,
              ),
            ),
          );
        },
      ),
    );
  }
}
