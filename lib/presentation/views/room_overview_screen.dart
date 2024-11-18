import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter/material.dart';

class RoomOverviewScreen extends StatelessWidget {
  final String roomName;

  const RoomOverviewScreen({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final roomData = {
      'Temperature': {'value': '22°C', 'status': 'good'},
      'Humidity': {'value': '45%', 'status': 'medium'},
      'Air Quality': {'value': '350 ppm', 'status': 'bad'},
    };

    final outsideData = {
      'Temperature': {'value': '18°C', 'status': 'medium'},
      'Humidity': {'value': '55%', 'status': 'good'},
      'Air Quality': {'value': '400 ppm', 'status': 'bad'},
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left_rounded),
            iconSize: 35,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/main');
            }),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: Text(
          roomName,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              'Room Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: DataDisplayBox(
                    title: 'This Room',
                    data: roomData,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DataDisplayBox(
                    title: 'Outside',
                    data: outsideData,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 8),
                height: 200, // Reduced height since removing button
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        const Text(
                          'EnviroScore',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          icon: const Icon(
                            Icons.info_outline,
                            size: 30,
                            color: AppColors.blackColor,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: const Text(
                                    'About EnviroScore',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    'EnviroScore is a measure of environmental quality based on various factors including air quality, temperature, and humidity levels in your space.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Got it',
                                        style: TextStyle(
                                            color: AppColors.primaryColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppColors.lightGrayColor,
                      thickness: 1,
                      height: 0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '85',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        Text(
                          '%',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.normal,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataDisplayBox extends StatelessWidget {
  final String title;
  final Map<String, Map<String, dynamic>>
      data; // Updated type to include status

  const DataDisplayBox({
    super.key,
    required this.title,
    required this.data,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return AppColors.greenColor;
      case 'bad':
        return AppColors.redColor;
      case 'medium':
        return AppColors.secondaryColor;
      default:
        return AppColors.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accentColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...data.entries.map((entry) => ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor,
                  ),
                ),
                trailing: Text(
                  entry.value['value'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(entry.value['status']),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
