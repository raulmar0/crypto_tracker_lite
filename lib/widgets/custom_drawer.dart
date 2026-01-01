import 'package:crypto_tracker_lite/pages/favorites_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(
        0xFF1E1E1E,
      ), // Slightly lighter than scaffold for contrast
      child: SafeArea(
        // Ensure content is not hidden by notches/status bars
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Header
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glowing effect
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withValues(alpha: 0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.yellow, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://i.pravatar.cc/300?img=11',
                        ), // Placeholder image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bryan Vazquez',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'bryan@correo.com',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.star,
                    iconColor: Colors.yellow,
                    iconBgColor: Colors.yellow.withValues(alpha: 0.2),
                    title: 'Favoritos',
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildMenuItem(
                    icon: Icons.person,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue.withValues(alpha: 0.2),
                    title: 'Perfil',
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  _buildMenuItem(
                    icon: Icons.settings,
                    iconColor: Colors.grey,
                    iconBgColor: Colors.grey.withValues(alpha: 0.2),
                    title: 'Configuración',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // Lighter background for items
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
      ),
    );
  }
}
