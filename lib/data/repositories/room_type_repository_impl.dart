import 'package:envirosense/data/datasources/room_type_data_source.dart';
import 'package:envirosense/domain/entities/roomtype.dart';
import 'package:envirosense/domain/repositories/room_type_repository.dart';

class RoomTypeRepositoryImpl implements RoomTypeRepository {
  final RoomTypeDataSource remoteDataSource;

  RoomTypeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RoomType>> getRoomTypes() async {
    return await remoteDataSource.getRoomTypes();
  }
}
