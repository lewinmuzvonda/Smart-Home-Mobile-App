
// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:arkenergyapp/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'package:toastification/toastification.dart';

class Data extends StatefulWidget {
  Data();

    @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {

  List<Map<String, dynamic>> devices = [];
  bool isLoading = true;
  Timer? _timer;
  String LeftWindowStatus = '';
  String RightWindowStatus = '';
   String AcStatus = '';
  

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      fetchData();
    });
  }

    @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  

  Future<void> fetchData() async {
    final url = Uri.parse('${endpoint}data');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          devices = List<Map<String, dynamic>>.from(data['devices']);
          isLoading = false;
          LeftWindowStatus = devices[0]['SwitchStatus'];
          RightWindowStatus = devices[2]['SwitchStatus'];
          AcStatus = devices[1]['SwitchStatus'];
        });

        print(devices);
        _checkDevicesStatus(LeftWindowStatus,AcStatus,RightWindowStatus);
        // _checkDevicesStatus('on',AcStatus,RightWindowStatus); //ac test

      } else {

        setState(() {
          isLoading = false;
        });
        
        toastification.show(
          title: const Text('An error occured', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
          context: context,
          description: const Text('An error occured while fetching data', style: TextStyle(color: darkpurple),),
          autoCloseDuration: const Duration(seconds: 5),
          icon: const Icon(Icons.error),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
        );
        
        throw Exception('Failed to load data');
      }
    } catch (error) {
      
      print('Error fetching device data: $error');

      setState(() {
        isLoading = false;
      });

      toastification.show(
        context: context,
        title: const Text('An error occured while fetching data.', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
        description: const Text('Please contact admin for assistance', style: TextStyle(color: darkpurple),),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(Icons.error),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
      );

      
    }
  }

  Future<void> checkDevices() async {
    final url = Uri.parse('${endpoint}data');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          devices = List<Map<String, dynamic>>.from(data['devices']);
          isLoading = false;
          LeftWindowStatus = devices[0]['SwitchStatus'];
          RightWindowStatus = devices[2]['SwitchStatus'];
          AcStatus = devices[1]['SwitchStatus'];
        });

        print(devices);

      } else {

        setState(() {
          isLoading = false;
        });
        
        toastification.show(
          title: const Text('An error occured', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
          context: context,
          description: const Text('An error occured while fetching data', style: TextStyle(color: darkpurple),),
          autoCloseDuration: const Duration(seconds: 5),
          icon: const Icon(Icons.error),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
        );
        
        throw Exception('Failed to load data');
      }
    } catch (error) {
      
      print('Error fetching device data: $error');

      setState(() {
        isLoading = false;
      });

      toastification.show(
        context: context,
        title: const Text('An error occured while fetching data.', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
        description: const Text('Please contact admin for assistance', style: TextStyle(color: darkpurple),),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(Icons.error),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
      );

      
    }
  }

  Future<void> toggleAC( BuildContext context ) async {

    setState(() {
        isLoading = true;
      });

    final url = Uri.parse('${endpoint}toggle-ac');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final status = json.decode(response.body);
        setState(() {
          isLoading = false;
        });

        print(status);

      } else {

        setState(() {
          isLoading = false;
        });
        
        toastification.show(
          title: const Text('An error occured', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
          context: context,
          description: const Text('An error occured while toggling AC', style: TextStyle(color: darkpurple),),
          autoCloseDuration: const Duration(seconds: 5),
          icon: const Icon(Icons.error),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
        );
        
        throw Exception('Failed to toggle AC');
      }
    } catch (error) {
      
      print('Error toggling AC: $error');

      setState(() {
        isLoading = false;
      });

      toastification.show(
        context: context,
        title: const Text('An error occured while fetching data.', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
        description: const Text('Please contact admin for assistance', style: TextStyle(color: darkpurple),),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(Icons.error),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
      );

      
    }
  }

  void _checkDevicesStatus(String LeftWindow,String AC,String RightWindow) {
    print('$LeftWindow $AC $RightWindow');
    if ((LeftWindow == "on" || RightWindow == 'on') && AC == 'on') {

      print("AC is ON whilst windows are open, AC will be switched in 3 minutes.");
         toastification.show(
            context: context,
            title: const Text('Windows and AC are both Open', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
            description: const Text("AC is ON whilst windows are open, AC will be switched in 3 minutes.", style: TextStyle(color: darkpurple),),
            autoCloseDuration: const Duration(seconds: 5),
            icon: const Icon(Icons.error),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
          );
      
      _timer = Timer(const Duration(minutes: 3), () {

        //check windows after 3 minutes
        checkDevices();
        
        if ( LeftWindowStatus == "on" || RightWindowStatus == 'on' ) {
          toggleAC(context);
          
          print("AC has been turned off because the window was still open after 3 minutes");
          toastification.show(
            context: context,
            title: const Text('AC Switched OFF', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
            description: const Text("AC has been turned off because the window was still open after 3 minutes", style: TextStyle(color: darkpurple),),
            autoCloseDuration: const Duration(seconds: 5),
            icon: const Icon(Icons.error),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
          );
        }
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Monitor'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          :  devices.isNotEmpty ? 
          RefreshIndicator(
          onRefresh: fetchData,
          child:
          ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
               return device['success'] == true ?  _buildDeviceCard(device) 
               :  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      device['error'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: red
                      ),
                      )
                  ]);
              },
            ),): const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Text(
                      'We could not fetch your devices\' data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: red
                      ),
                      )
              ],
            ),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    final String deviceId = device['deviceId'];
    final String switchStatus = device['SwitchStatus'] ?? 'Unknown';
    final int energyConsumption = device['currentKwh'] ?? -10000;
    final String type = device['type'];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF111134), Color(0xFF101D43), Color(0xFF240D6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHighlightedDetailRow('Device', type),
            const SizedBox(height: 10),
            _buildDashedDivider(),
            const SizedBox(height: 10),
            _buildDetailRow('Status', switchStatus.toUpperCase(), type),
            const SizedBox(height: 10),
            if(type == 'AC')
            _buildDashedDivider(),
            if(type == 'AC')
            const SizedBox(height: 10),
            if(energyConsumption > -10000)
            _buildHighlightedDetailRow(
              'Energy Consumption','$energyConsumption kWh'
            ),
            if(energyConsumption > -10000)
            const SizedBox(height: 20),
            if(type == 'AC')
            _buildSwipeButton(context, switchStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String type) {

    if(type != 'AC' && value == 'ON'){
      value = 'Open';
    }else if(type != 'AC' && value == 'OFF'){
       value = 'Closed';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightedDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF240D6E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: List.generate(1000 ~/ 10, (index) {
          return Expanded(
            child: Container(
              color: index % 2 == 0 ? Colors.white : Colors.transparent,
              height: 0.5,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSwipeButton(BuildContext context, String switchStatus) {
    return Container(
        alignment: Alignment.center,
        child: 
          ElevatedButton(
            onPressed: () async {

              print(AcStatus);

              await toggleAC(context);
              await checkDevices();

              if(AcStatus == 'on'){

                toastification.show(
                  title: const Text('AC turned OFF', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
                  context: context,
                  autoCloseDuration: const Duration(seconds: 5),
                  icon: const Icon(Icons.power, color: red,),
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                );

              }else{

                toastification.show(
                  title: const Text('AC turned ON', style: TextStyle(color: black, fontWeight: FontWeight.bold)),
                  context: context,
                  autoCloseDuration: const Duration(seconds: 5),
                  icon: const Icon(Icons.offline_bolt),
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                );

              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AcStatus == 'on' ? red : green,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AcStatus == 'on' ? 'SWITCH OFF AC' : 'SWITCH ON AC',
              style: const TextStyle(
                fontSize: 16, 
                color: white, 
                fontWeight: FontWeight.bold
                ),
              textAlign: TextAlign.center,
            ),
          ),
    );
  }

}