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
  //late Future<List<Product>?> _productsFuture;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_productsFuture = fetchProductInfo();
  }
/*
  Future<List<Product>?> fetchProductInfo() async {
    try {
      final products = await getProductInfo();
      return products;
    } catch (e) {
      return null;
    }
  }

  Future<void> searchProducts(String keyword) async {
    setState(() {
      _productsFuture = getSearchProduct(keyword);
    });
  }

  // Update sorting and refresh products
  void updateSorting(String sortBy, String order) {
    setState(() {
      _selectedSortBy = sortBy;
      _selectedOrder = order;
      _productsFuture = getSortProducts(_selectedSortBy, _selectedOrder);
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.user.firstName}"),
        actions: [],
      ),
      drawer: CustomDrawer(user: widget.user),
      body: const Center(child: Text("You are logged in"),)
    );
  }
}