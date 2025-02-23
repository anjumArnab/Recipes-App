import 'package:company_app/model/recipe.dart';
import 'package:company_app/services/api_services.dart';
import 'package:company_app/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _recipeFuture = fetchRecipeInfo();
  }

  Future<List<Recipe>?> fetchRecipeInfo() async {
    try {
      final recipes = await getRecipe(); // Ensure getRecipe() returns List<Recipe>
      return recipes;
    } catch (e) {
      return null;
    }
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
            const SizedBox(height: 10),
            const Text(
              'What Do You Want To Cook Today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
              onChanged: (_) {},
            ),
            const SizedBox(height: 20),

            // Categories Section
            Expanded(
              flex: 2,
              child: PageView.builder(
                itemCount: (categories.length / 8).ceil(),
                controller: PageController(viewportFraction: 1),
                itemBuilder: (context, pageIndex) {
                  int startIndex = pageIndex * 8;
                  int endIndex = (startIndex + 8) > categories.length
                      ? categories.length
                      : startIndex + 8;
                  List<Map<String, String>> pageItems =
                      categories.sublist(startIndex, endIndex);
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: pageItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            pageItems[index]['icon']!,
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            pageItems[index]['label']!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black87),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Recipes Section
            Expanded(
              flex: 5,
              child: Recipes(future: _recipeFuture),
            ),
          ],
        ),
      ),
    );
  }
}

// Recipes Widget with FutureBuilder Inside
class Recipes extends StatelessWidget {
  final Future<List<Recipe>?> future;

  const Recipes({super.key, required this.future});

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
          return RecipeGrid(recipes: snapshot.data!);
        }
      },
    );
  }
}

// GridView to Display Recipes
class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeGrid({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(
            image: recipe.image,
            name: recipe.name,
            cuisine: recipe.cuisine,
            difficulty: recipe.difficulty,
          );
        },
      ),
    );
  }
}
