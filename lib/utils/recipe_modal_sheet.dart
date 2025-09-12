// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../model/recipe.dart';

class RecipeModalSheet extends StatefulWidget {
  final Recipe recipe;

  const RecipeModalSheet({super.key, required this.recipe});

  @override
  State<RecipeModalSheet> createState() => _RecipeModalSheetState();
}

class _RecipeModalSheetState extends State<RecipeModalSheet> {
  int selectedIndex = 1; // Default to "Instructions" selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.recipe.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${widget.recipe.cuisine} | ${widget.recipe.difficulty} | ${widget.recipe.caloriesPerServing} kcal",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),

                        // Recipe Buttons Integration
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildButton(0, Icons.list, "Ingredients"),
                            buildButton(
                                1, Icons.restaurant_menu, "Instructions"),
                            buildButton(2, Icons.comment, "Review"),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Display content based on selected tab
                        if (selectedIndex == 0) ...[
                          // Show Ingredients
                          ...List.generate(widget.recipe.ingredients.length,
                              (index) {
                            return ingredientTile(
                                index + 1, widget.recipe.ingredients[index]);
                          }),
                        ] else if (selectedIndex == 1) ...[
                          // Show Instructions
                          ...List.generate(widget.recipe.instructions.length,
                              (index) {
                            return instructionTile(
                                index + 1, widget.recipe.instructions[index]);
                          }),
                        ] else if (selectedIndex == 2) ...[
                          // Show Reviews
                          reviewTile(),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget instructionTile(int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent,
            radius: 15,
            child: Text(
              step < 10 ? "0$step" : "$step",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget ingredientTile(int index, String ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent.withOpacity(0.1),
            radius: 15,
            child: const Icon(
              Icons.check,
              color: Colors.deepOrangeAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star_outline,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Reviews",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Reviews will be implemented soon!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Coming features:\n• User ratings\n• Written reviews\n• Photo reviews",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Button Builder without Modal Sheet
  Widget buildButton(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrangeAccent : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.deepOrangeAccent),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : Colors.deepOrangeAccent,
                size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.deepOrangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
