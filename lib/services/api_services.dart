import 'dart:convert';
import 'package:company_app/model/company_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl = 'https://retoolapi.dev/H1Ohqj/company';

  // Create company
  Future<Company> createCompany(Company company) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(company.toJson()),
    );

    if (response.statusCode == 201) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create company');
    }
  }

  // Read all companies
  Future<List<Company>> getCompanies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Company.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  // Read a single company by ID
  Future<Company> getCompanyById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load company');
    }
  }

  // Update company
  Future<Company> updateCompany(int id, Company company) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(company.toJson()),
    );

    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update company');
    }
  }

  // Delete company
  Future<void> deleteCompany(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete company');
    }
  }
}
