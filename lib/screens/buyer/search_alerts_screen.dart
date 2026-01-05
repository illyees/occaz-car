import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import 'package:intl/intl.dart';

class SearchAlertsScreen extends StatefulWidget {
  const SearchAlertsScreen({Key? key}) : super(key: key);

  @override
  State<SearchAlertsScreen> createState() => _SearchAlertsScreenState();
}

class _SearchAlertsScreenState extends State<SearchAlertsScreen> {
  final NotificationService _notificationService = NotificationService();
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'fr_FR', symbol: '€', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userId = authService.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Mes Alertes de Recherche'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notificationService.getSearchAlerts(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune alerte configurée',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Créez une alerte pour être notifié',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateAlertDialog(context, userId),
                    icon: const Icon(Icons.add_alert),
                    label: const Text('Créer une alerte'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                  ),
                ],
              ),
            );
          }

          final alerts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _buildAlertCard(alert, userId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAlertDialog(context, userId),
        icon: const Icon(Icons.add_alert),
        label: const Text('Nouvelle alerte'),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert, String userId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alerte de recherche',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Actif',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteAlert(userId, alert['id']),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            if (alert['brand'] != null) ...[
              _buildCriteriaRow(
                  Icons.directions_car, 'Marque', alert['brand']),
              const SizedBox(height: 8),
            ],
            if (alert['maxPrice'] != null) ...[
              _buildCriteriaRow(Icons.euro,
                  'Prix max.', currencyFormat.format(alert['maxPrice'])),
              const SizedBox(height: 8),
            ],
            if (alert['minYear'] != null) ...[
              _buildCriteriaRow(
                  Icons.calendar_today, 'Année min.', '${alert['minYear']}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _deleteAlert(String userId, String alertId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'alerte ?'),
        content:
            const Text('Vous ne recevrez plus de notifications pour cette recherche.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _notificationService.deleteSearchAlert(userId, alertId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alerte supprimée')),
        );
      }
    }
  }

  void _showCreateAlertDialog(BuildContext context, String userId) {
    final formKey = GlobalKey<FormState>();
    String? selectedBrand;
    double? maxPrice;
    int? minYear;

    final List<String> brands = [
      'Renault',
      'Peugeot',
      'Citroën',
      'Toyota',
      'Volkswagen',
      'BMW',
      'Mercedes',
      'Audi',
      'Ford',
      'Nissan',
      'Hyundai',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer une alerte'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Vous serez notifié lorsqu\'une nouvelle annonce correspondra à vos critères',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Marque (optionnel)',
                    prefixIcon: Icon(Icons.directions_car),
                    border: OutlineInputBorder(),
                  ),
                  items: brands
                      .map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          ))
                      .toList(),
                  onChanged: (value) => selectedBrand = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Prix maximum (€)',
                    prefixIcon: Icon(Icons.euro),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      maxPrice = double.tryParse(value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Année minimum',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      minYear = int.tryParse(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _notificationService.saveSearchCriteria(
                userId: userId,
                brand: selectedBrand,
                maxPrice: maxPrice,
                minYear: minYear,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alerte créée avec succès !')),
                );
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}
