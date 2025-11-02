// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'ledger_screen.dart';
import 'reminders_screen.dart';
import 'crops_screen.dart';
import 'weather_alert_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Pages are not const because some page widgets may not have const ctors.
  final List<Widget> _pages = [
    LedgerScreen(),
    RemindersScreen(),
    CropsScreen(),
    WeatherAlertScreen(),
  ];

  final List<String> _titles = [
    'Ledger',
    'Reminders',
    'Crops Knowledge',
    'Weather Alerts',
  ];

  void _onItemTapped(int index) {
    if (index < 0 || index >= _pages.length) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if individual pages need to receive callbacks or services, inject them here
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 2,
        centerTitle: false,
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Ledger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_outlined),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Crops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_outlined),
            label: 'Weather',
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    // Example: show context-aware FAB (add entry / add reminder / add crop)
    switch (_selectedIndex) {
      case 0: // Ledger
        return FloatingActionButton(
          onPressed: () {
            // Navigate to add ledger or show dialog - implement as needed
            // Example: show simple dialog to add ledger (or route to ledger page editor)
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green.shade700,
          tooltip: 'Add ledger entry',
        );
      case 1: // Reminders
        return FloatingActionButton(
          onPressed: () {
            // Focus the reminders input field if implemented; otherwise navigate
          },
          child: const Icon(Icons.add_alert),
          backgroundColor: Colors.green.shade700,
          tooltip: 'Add reminder',
        );
      case 2: // Crops
        return FloatingActionButton(
          onPressed: () {
            // Navigate to crop add form if implemented
          },
          child: const Icon(Icons.add_box_outlined),
          backgroundColor: Colors.green.shade700,
          tooltip: 'Add crop tip',
        );
      default:
        return null; // no FAB on Weather screen
    }
  }
}
