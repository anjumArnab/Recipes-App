import 'package:company_app/model/company_model.dart';
import 'package:company_app/screens/create_company.dart';
import 'package:company_app/services/api_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Company>> futureCompanies;

  @override
  void initState() {
    super.initState();
    // Initial fetch of the companies
    futureCompanies = ApiServices().getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Company Info Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh the companies list
              setState(() {
                futureCompanies = ApiServices().getCompanies();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Company>>(
        future: futureCompanies,
        builder: (context, snapshot) {
          // Check connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No companies available'));
          } else {
            // If data is available, show the companies list
            final companies = snapshot.data!;
            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (BuildContext context, int index) {
                final company = companies[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Company Logo
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(company.logo), // Set company logo
                        ),
                        const SizedBox(width: 12),
                        // Company Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.companyName, // Display company name
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(company
                                  .companyNumber), // Display company number
                              const SizedBox(height: 4),
                              Text(company
                                  .companyAddress), // Display company address
                            ],
                          ),
                        ),
                        // Action Buttons
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateCompany(
                                      name: company.companyName,
                                      address: company.companyAddress,
                                      phone: company.companyNumber,
                                      logo: company.logo, // changes to be made
                                      isEditing: true,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "Are you sure you want to delete this company?",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle delete logic here
                                          },
                                          child: const Text("Yes"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade300,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          backgroundColor: Colors.blue.shade300,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateCompany(
                  name: '', // Empty value for name
                  address: '', // Empty value for address
                  phone: '', // Empty value for phone number
                  logo: '', // Empty value for logo
                  isEditing: false, // Indicates that this is not an edit action
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
