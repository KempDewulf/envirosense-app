// lib/views/statistics_detail_screen.dart
import 'package:envirosense/data/datasources/statistics_data_source.dart';
import 'package:envirosense/data/repositories/statistics_repository_impl.dart';
import 'package:envirosense/domain/entities/building_statistics.dart';
import 'package:envirosense/presentation/controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class StatisticsDetailScreen extends StatefulWidget {
  const StatisticsDetailScreen({super.key});

  @override
  State<StatisticsDetailScreen> createState() => _StatisticsDetailScreenState();
}

class _StatisticsDetailScreenState extends State<StatisticsDetailScreen> {
  late final StatisticsController _controller;
  EnviroScore? buildingScore;
  Map<String, EnviroScore> roomScores = {};
  final List<Map<String, dynamic>> rooms = [
    {'name': '3.108', 'enviroScore': 85},
    {'name': '3.109', 'enviroScore': 65},
    {'name': '3.110', 'enviroScore': 92},
  ];

  Color _getScoreColor(int score) {
    if (score >= 75) {
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
    _controller = StatisticsController(
      StatisticsRepositoryImpl(
        remoteDataSource: StatisticsDataSource(),
      ),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final score = await _controller.getBuildingEnviroScore();
      final roomIds = rooms.map((room) => room['name'].toString()).toList();
      final scores = await Future.wait(
          roomIds.map((id) => _controller.getRoomEnviroScore(id)));

      setState(() {
        buildingScore = score;
        for (var i = 0; i < roomIds.length; i++) {
          roomScores[roomIds[i]] = scores[i];
          // Update the room scores in the rooms list
          rooms[i]['enviroScore'] = scores[i].score.round();
        }
      });
    } catch (e) {
      // Handle error
      debugPrint('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate 25% of the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    double topBackgroundHeight = screenHeight * 0.15;

    return Scaffold(
      backgroundColor: AppColors.whiteColor, // All white underneath
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // Primary color
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: AppColors.whiteColor,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
        ),
        centerTitle: true,
        title: const Text(
          'Building Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background and content
          SingleChildScrollView(
            child: Column(
              children: [
                // Top background container
                Container(
                  height: topBackgroundHeight,
                  color: AppColors.primaryColor,
                ),
                // Rest of the content
                Container(
                  color: AppColors.whiteColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 90), // Space for overlapping card
                      // ROOMS Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
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
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              child: const Text(
                                'ROOMS',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Rooms List
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rooms.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final room = rooms[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/roomOverview',
                                      arguments: {
                                        'roomName': room['name'],
                                        // Pass other required arguments
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
                                            color: _getScoreColor(room[
                                                'enviroScore']), // Dynamic color based on score
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${room['enviroScore']}%',
                                            style: const TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Room Title
                                        Expanded(
                                          child: Text(
                                            room['name'],
                                            style: const TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // Arrow Icon
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: AppColors.blackColor,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned EnviroScore card
          Positioned(
            top: topBackgroundHeight - 80,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.zero,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'EnviroScore',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          icon: const Icon(
                            Icons.info_outline,
                            size: 24,
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
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '85',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
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
