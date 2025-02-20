import 'package:company_app/model/auth_user.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final AuthUser user;

  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("${user.firstName} ${user.lastName}", style: const TextStyle(color: Colors.black),),
            accountEmail: Text(user.phone, style: const TextStyle(color: Colors.black),),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.image),
            ),
            decoration: const BoxDecoration(
              color: Colors.white10,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cake),
            title: Text("Birthdate: ${user.birthDate}"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // Add logout functionality here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}