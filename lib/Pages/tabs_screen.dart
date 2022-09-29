import 'package:finance_app/Pages/home_page.dart';
import 'package:finance_app/Pages/transactions_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'community_page.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPage = 0;

  final _pageOptions = [
    const HomePage(),
    const TransactionsPage(),
    const CommunityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions.elementAt(_selectedPage),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              haptic: true,
              gap: 4,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: CupertinoIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: CupertinoIcons.square_stack_3d_up,
                  text: 'Transactions',
                ),
                GButton(
                  icon: CupertinoIcons.heart,
                  text: 'Community',
                ),
              ],
              selectedIndex: _selectedPage,
              onTabChange: (index) {
                setState(() {
                  _selectedPage = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
