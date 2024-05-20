import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../services/user_services.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> _selectedUsers = [];
  int _page = 1;
  int _perPage = 10;
  bool _isLoading = false;

  List<UserModel> get users => _users;
  List<UserModel> get selectedUsers => _selectedUsers;
  bool get isLoading => _isLoading;

  final UserService _apiService = UserService();

  UserProvider() {
    _loadSelectedUsers();
  }

  // Fetch users
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<UserModel> fetchedUsers =
          await _apiService.getUsers(page: _page, perPage: _perPage);
      _users.addAll(fetchedUsers);
      _page++;
    } catch (e) {
      print('Error fetching users: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Delete user
  Future<void> deleteUser(int userId) async {
    try {
      await _apiService.deleteUser(userId);
      // Remove the user from the local list
      _users.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Select user
  void selectUser(UserModel user) {
    _users.remove(user);
    _selectedUsers.add(user);
    _saveSelectedUsers();
    notifyListeners();
  }

  // Deselect user
  void deselectUser(UserModel user) {
    _selectedUsers.remove(user);
    _users.add(user);
    _saveSelectedUsers();
    notifyListeners();
  }

  // Save selected users to local storage
  Future<void> _saveSelectedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> selectedUsersJson =
        _selectedUsers.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('selected_users', selectedUsersJson);
  }

  // Load selected users from local storage
  Future<void> _loadSelectedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? selectedUsersJson = prefs.getStringList('selected_users');
    if (selectedUsersJson != null) {
      _selectedUsers = selectedUsersJson
          .map((userJson) => UserModel.fromJson(jsonDecode(userJson)))
          .toList();
    }
    notifyListeners();
  }

  // Convert user to JSON
  Map<String, dynamic> toJson(UserModel user) => {
        'id': user.id,
        'email': user.email,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'avatar': user.avatar,
      };

  // Create User
  Future<void> createUser(String name, String job) async {
    try {
      await _apiService.createUser(name, job);
      notifyListeners();
    } catch (error) {
      print('Error creating user: $error');
      throw error;
    }
  }

  // Update User
  Future<void> updateUser(int userId, String name, String job) async {
    try {
      await _apiService.updateUser(userId, name, job);
      _users = _users.map((user) {
        if (user.id == userId) {
          return UserModel(
            id: user.id,
            email: user.email,
            firstName: name.split(' ')[0],
            lastName: name.split(' ').length > 1 ? name.split(' ')[1] : '',
            avatar: user.avatar,
          );
        }
        return user;
      }).toList();
      notifyListeners();
    } catch (error) {
      print('Error updating user: $error');
      throw error;
    }
  }
}
