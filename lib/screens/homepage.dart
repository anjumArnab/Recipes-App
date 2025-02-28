import 'package:company_app/utils/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:company_app/model/recipe.dart';
import 'package:company_app/services/api_services.dart';
import 'package:company_app/widgets/recipe_card.dart';
import 'package:company_app/model/auth_user.dart';
import 'package:company_app/widgets/custome_drawer.dart';

class HomePage extends StatefulWidget {
  final AuthUser user;

  const HomePage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
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

  late Future<List<Recipe>?> _recipeFuture;
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showCategories = true;

  @override
  void initState() {
    super.initState();
    _recipeFuture = fetchRecipeInfo();

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

  Future<List<Recipe>?> fetchRecipeInfo() async {
    try {
      final recipes = await getRecipe();
      return recipes;
    } catch (e) {
      return null;
    }
  }

  Future<void> searchRecipe(String keyword) async {
    setState(() {
      _recipeFuture = fetchRecipes(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.user.firstName}"),
      ),
      drawer: CustomDrawer(user: widget.user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              'What Do You Want To Cook Today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: 'Search Recipe',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  searchRecipe(value);
                } else {
                  setState(() {
                    _recipeFuture = fetchRecipeInfo();
                  });
                }
              },
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showCategories ? 100 : 0,
              child: _showCategories
                  ? SizedBox(
                      height: 80,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
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
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Recipes(
                  future: _recipeFuture, scrollController: _scrollController),
            ),
          ],
        ),
      ),
    );
  }
}

class Recipes extends StatelessWidget {
  final Future<List<Recipe>?> future;
  final ScrollController scrollController;

  const Recipes(
      {super.key, required this.future, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading recipes'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recipes found'));
        } else {
          return RecipeGrid(
              recipes: snapshot.data!, scrollController: scrollController);
        }
      },
    );
  }
}

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final ScrollController scrollController;

  const RecipeGrid(
      {super.key, required this.recipes, required this.scrollController});

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
                    builder: (context) => RecipeScreen(recipe: recipe),
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
