import 'package:cloud_firestore/cloud_firestore.dart';

enum HistoryType { maintenance, repair, damage }

class VehicleHistory {
  final String id;
  final String vehicleId;
  final HistoryType type;
  final String title;
  final String description;
  final DateTime date;
  final double? cost;
  final String? workshopName;
  final List<String> images;
  final int? mileageAtService;
  final DateTime createdAt;

  VehicleHistory({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    this.cost,
    this.workshopName,
    this.images = const [],
    this.mileageAtService,
    required this.createdAt,
  });

  factory VehicleHistory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return VehicleHistory(
      id: doc.id,
      vehicleId: data['vehicleId'] ?? '',
      type: HistoryType.values.firstWhere(
        (e) => e.toString() == 'HistoryType.${data['type']}',
        orElse: () => HistoryType.maintenance,
      ),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      cost: data['cost']?.toDouble(),
      workshopName: data['workshopName'],
      images: List<String>.from(data['images'] ?? []),
      mileageAtService: data['mileageAtService'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'cost': cost,
      'workshopName': workshopName,
      'images': images,
      'mileageAtService': mileageAtService,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get typeLabel {
    switch (type) {
      case HistoryType.maintenance:
        return 'Entretien';
      case HistoryType.repair:
        return 'Réparation';
      case HistoryType.damage:
        return 'Dégât';
    }
  }
}
