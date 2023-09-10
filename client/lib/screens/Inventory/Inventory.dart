import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../globals.dart';
import '../../models/Inventory_Model.dart';
import '../../widgets/Appbar.dart';
import '../../widgets/BottomAppBar.dart';
import '../../widgets/categories.dart';
import '../../widgets/AssignCardInv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'item_model.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final AuthController authController = AuthController();
  Future<List<ItemModel>> fetchItemsFromApi() async {
    final token = await authController.getToken();
    var url = Uri.https(baseUrl, '/inv/viewallitem');
    final response = await http.post(
      url,
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body)['data'];
      print(data);
      return data.values
          .map((itemData) => ItemModel.fromJson(itemData)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }
  late List<ItemModel> items;
  late Map<String, List<ItemModel>> groupedItems ={};
  String selectedType = '';
  @override
  void initState() {
    super.initState();
    fetchItemsFromApi().then((fetchedItems) {
      setState(() {
        items = fetchedItems;
        groupedItems = groupItemsByType(items);
      });
    });
  }
  Map<String, List<ItemModel>> groupItemsByType(List<ItemModel> items) {
    Map<String, List<ItemModel>> groupedItems = {};
    for (var item in items) {
      if (groupedItems.containsKey(item.itemType)) {
        groupedItems[item.itemType]!.add(item);
      } else {
        groupedItems[item.itemType] = [item];
      }
    }
    return groupedItems;
  }
  ListView buildTypeButtons(List<String> itemTypes) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemTypes.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedType = itemTypes[index];
            });
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: selectedType == itemTypes[index]
                  ? Colors.blue
                  : Colors.grey,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              itemTypes[index],
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }


  Future<void> deleteItem(int deviceId) async {
    final token = await authController.getToken();
    var url = Uri.https(baseUrl, '/inv/deleteitem');
    final response = await http.post(
      url,
      headers: {'Cookie': token!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      setState(() {
        items.removeWhere((item) => item.deviceId == deviceId);
      });
      print('Item with device ID $deviceId deleted');
    } else {
      print('Failed to delete item. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  ListView buildDeviceList(List<ItemModel> devices) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(devices[index].deviceDetail),
          subtitle: Text('Cost: ${devices[index].cost}'),
          trailing: IconButton(
            icon: Icon(Icons.delete), // Add a delete icon
            onPressed: () {
              deleteItem(devices[index].deviceId);
            },
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    List<String> itemTypes = groupedItems.keys.toList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future:fetchItemsFromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Placeholder for loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else{
            return SafeArea(
              child:
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 11.0),
                      child: Appbar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 23.0,bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Categories", style: TextStyle(color: Color(0xffE96E2B), fontWeight: FontWeight.w600, fontSize: 14.0 )),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, '/AddDevice');
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 6.5,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(Icons.add, color: Color(0xffE96E2B), size: 13,),
                                ),
                                Text("Add Device",style: TextStyle(color: Color(0xffE96E2B)),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Categories(title: "Mobile", svgpath:'assets/svgs/Mobile.svg', onpress: (){}).buildCategories(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Categories(title: "Audio", svgpath:'assets/svgs/mic.svg', onpress: (){}).buildCategories(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Categories(title: "Accessories", svgpath:'assets/svgs/Accessories.svg', onpress: (){}).buildCategories(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        children: [
                          for(var i=0;i<20;i++)
                            Padding(
                              padding: const EdgeInsets.symmetric( vertical: 5.0),
                              child: AssignCardInv(model: "Redmi 11i pro", cost: 4500),
                            ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );

          }
        },
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }
}
