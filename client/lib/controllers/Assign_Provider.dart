import 'package:flutter/material.dart';
import 'package:mobelease/models/Inventory_Model.dart';

class SelectedDevicesProvider extends ChangeNotifier {
  List<ItemModel> _selectedDevices = [];

  List<ItemModel> get selectedDevices => _selectedDevices;

  void addToSelectedDevices(ItemModel device) {
    _selectedDevices.add(device);
    notifyListeners();
  }

  void removeFromSelectedDevices(ItemModel device) {
    _selectedDevices.remove(device);
    notifyListeners();
  }
}
