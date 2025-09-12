import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/auth_user.dart';
import '../services/api_services.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  AuthState _state = AuthState.initial;
  AuthUser? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  String? _errorMessage;

  // Getters
  AuthState get state => _state;
  AuthUser? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  // Constructor - check for existing login
  AuthProvider() {
    _checkExistingLogin();
  }

  Future<void> _checkExistingLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token != null) {
        _accessToken = token;
        _refreshToken = prefs.getString('refresh_token'); // Fixed this line
        await _fetchCurrentUser();
      } else {
        _state = AuthState.unauthenticated;
        notifyListeners();
      }
    } catch (e) {
      _state = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _setState(AuthState.loading);
    _clearError();

    try {
      final authResponse = await _apiService.loginUser(username, password);

      if (authResponse != null) {
        _accessToken = authResponse.accessToken;
        _refreshToken = authResponse.refreshToken;

        // Save tokens to shared preferences
        await _saveTokens();

        // Fetch current user data
        await _fetchCurrentUser();

        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError('Invalid credentials');
        _setState(AuthState.unauthenticated);
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      _setState(AuthState.error);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Clear tokens from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');

      // Clear provider state
      _accessToken = null;
      _refreshToken = null;
      _currentUser = null;
      _clearError();

      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Logout failed: $e');
    }
  }

  Future<void> _fetchCurrentUser() async {
    if (_accessToken == null) return;

    try {
      final user =
          await _apiService.getCurrentUser(_accessToken!); // Fixed this line
      if (user != null) {
        _currentUser = user;
      } else {
        // Token might be expired, logout
        await logout();
      }
    } catch (e) {
      print('Error fetching current user: $e');
      await logout();
    }
  }

  Future<void> _saveTokens() async {
    final prefs = await SharedPreferences.getInstance();
    if (_accessToken != null) {
      await prefs.setString('access_token', _accessToken!);
    }
    if (_refreshToken != null) {
      await prefs.setString('refresh_token', _refreshToken!);
    }
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Method to refresh user data
  Future<void> refreshUserData() async {
    if (_accessToken != null) {
      await _fetchCurrentUser();
      notifyListeners();
    }
  }
}
