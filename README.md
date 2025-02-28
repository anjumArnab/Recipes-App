# Recipe App

Recipe App is a simple API integration project that fetches recipe data from [DummyJSON](https://dummyjson.com/docs/recipes). It allows users to retrieve all recipes, search for specific recipes, and sort results by title in ascending or descending order.

## Features

- **Get All Recipes**: Fetch and display a list of all available recipes.
- **Search Recipes**: Find specific recipes by entering a search query.
- **Sorting**: Sort recipes by title in ascending or descending order.

## API Endpoints Used

- **Get all recipes**: `https://dummyjson.com/recipes`
- **Search recipes**: `https://dummyjson.com/recipes/search?q={query}`
- **Sorting**: `https://dummyjson.com/recipes?sortBy={name}&order={order}`