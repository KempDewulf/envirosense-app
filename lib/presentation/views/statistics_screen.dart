import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/entities/room_type.dart';
import 'package:envirosense/presentation/widgets/enviro_score_card.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final List<Room> rooms = [];
  bool _buildingHasDeviceData = false;

  Color _getScoreColor(int score) {
    if (score >= 85) {
      return AppColors.greenColor;
    } else if (score >= 50) {
      return AppColors.secondaryColor;
    } else {
      return AppColors.redColor;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load data from API
      List<Room> mockRooms = List.generate(
          15,
          (index) => Room(
              id: (index + 1).toString(),
              name: "Room ${index + 1}",
              building: Building(
                  id: "${(index % 3) + 1}", // Creates 3 different buildings
                  name: "Building ${(index % 3) + 1}",
                  address: "Address ${(index % 3) + 1}"),
              roomType: RoomType(
                  id: "${(index % 4) + 1}", // Creates 4 different room types
                  name: "Type ${(index % 4) + 1}",
                  icon: "icon${(index % 4) + 1}")));

      setState(() {
        rooms.addAll(mockRooms);
        _buildingHasDeviceData = isDeviceDataAvailable();
      });
    } catch (e) {
      // Handle error
      debugPrint('Error loading data: $e');
    }
  }

  bool isDeviceDataAvailable() {
    return true; //TODO: see here for building
  }

  @override
  Widget build(BuildContext context) {
    // Calculate 25% of the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    double topBackgroundHeight = screenHeight * 0.10;

    return Scaffold(
      backgroundColor: AppColors.whiteColor, // All white underneath
      appBar: AppBar(
        title: Text(
          "Building Statistics",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
              fontSize: 22),
        ),
      ),
      body: Stack(
        children: [
          // Background and content
          Column(
            children: [
              // Top background container
              Container(
                height: topBackgroundHeight,
                color: AppColors.primaryColor,
              ),
              // Rest of the content
              Expanded(
                child: Container(
                  color: AppColors.whiteColor,
                  child: Column(
                    children: [
                      SizedBox(height: topBackgroundHeight + 30),
                      // ROOMS Card
                      Container(
                        height: MediaQuery.of(context).size.height -
                            topBackgroundHeight // Top blue section
                            -
                            kToolbarHeight // AppBar
                            -
                            100 // EnviroScore card
                            -
                            80 // Bottom navigation
                            -
                            50, // Additional padding/margins
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.secondaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: const Text(
                                'ROOMS',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Rooms List
                            Expanded(
                              child: ListView.separated(
                                itemCount: rooms.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 0),
                                itemBuilder: (context, index) {
                                  final room = rooms[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/roomOverview',
                                        arguments: {
                                          'roomId': room.id,
                                          'roomName': room.name,
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Row(
                                        children: [
                                          // EnviroScore Percentage
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              //TODO: getScoreColor() ---- Dynamic color based on score
                                              color: AppColors.greenColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              //TODO: have the calculated rooms enviroscore here
                                              '74.8%',
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          // Room Title
                                          Expanded(
                                              child: Container(
                                                  height: 60,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .primaryColor
                                                        .withAlpha(10),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        room.name,
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: AppColors
                                                            .primaryColor,
                                                        size: 16,
                                                      ),
                                                    ],
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
          // Positioned EnviroScore card
          Positioned(
            top: topBackgroundHeight - 70,
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            child: EnviroScoreCard(
              score: 75,
              onInfoPressed: _showEnviroScoreInfo,
              isDeviceDataAvailable: _buildingHasDeviceData,
            ),
          ),
        ],
      ),
    );
  }

  void _showEnviroScoreInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About EnviroScore'),
        content: const Text(
          'EnviroScore is a measure of environmental quality based on various factors including air quality, temperature, and humidity levels in your space.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
