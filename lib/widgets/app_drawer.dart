import 'package:flutter/material.dart';
import '../pages/account_page.dart';
import '../pages/favorites_page.dart';
import '../pages/search_page.dart';
import '../pages/collections_page.dart';
import '../pages/home_page.dart';
import '../style/app_drawer_style.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: DrawerStyles.drawerHeaderDecoration,
            child: Text(
              'Меню',
              style: DrawerStyles.drawerHeaderStyle,
            ),
            
          ),
           ListTile(
            leading: Icon(Icons.movie_filter),
            title: Text('Сейчас смотрят'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Избранное'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Поиск'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Подборки'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CollectionsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Аккаунт'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}