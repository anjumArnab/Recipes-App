import 'package:company_app/model/recipe.dart';
import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreen({super.key, required this.recipe});

  @override
  // ignore: library_private_types_in_public_api
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
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
                            buildButton(0, Icons.list, "Ingredients", widget.recipe.ingredients),
                            buildButton(1, Icons.restaurant_menu, "Instructions", widget.recipe.instructions),
                            buildButton(2, Icons.comment, "Review", ["Reviews will be implemented soon!"]),
                          ],
                        ),

                        const SizedBox(height: 20),
                        ...List.generate(widget.recipe.instructions.length, (index) {
                          return instructionTile(
                              index + 1, widget.recipe.instructions[index]);
                        }),
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.7) ,
          child: Text("0$step", style: const TextStyle(color: Colors.white)),
        ),
        title:
            Text("Step $step", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(instruction),
      ),
    );
  }

  // Button Builder with Modal Sheet Trigger
  Widget buildButton(int index, IconData icon, String label, List<String> content) {
    bool isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        showModal(context, label, content); // Show modal for selected tab
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.orange.withOpacity(0.7) ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.orange.withOpacity(0.7) , size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.orange.withOpacity(0.7) ,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showModal(BuildContext context, String title, List<String> content) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...content.map((item) => ListTile(title: Text(item))),
              ],
            ),
          ),
        );
      },
    );
  }
}
