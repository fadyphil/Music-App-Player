import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music_player/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:music_player/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:music_player/features/profile/domain/entities/user_entity.dart';
import 'package:music_player/features/profile/data/failures/profile_failure.dart';

class MockProfileLocalDataSource extends Mock implements ProfileLocalDataSource {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProfileLocalDataSource();
    repository = ProfileRepositoryImpl(mockDataSource);
  });

  const tUser = UserEntity(
    id: '1',
    username: 'Test User',
    email: 'test@example.com',
    avatarUrl: '',
    preferredNavBar: NavBarStyle.simple,
  );

  group('getUserProfile', () {
    test('should return UserEntity when call to data source is successful', () async {
      // Arrange
      when(() => mockDataSource.getUserProfile()).thenAnswer((_) async => tUser);
      // Act
      final result = await repository.getUserProfile();
      // Assert
      expect(result, equals(const Right(tUser)));
      verify(() => mockDataSource.getUserProfile()).called(1);
    });

    test('should return ProfileFailure when call to data source throws exception', () async {
      // Arrange
      when(() => mockDataSource.getUserProfile()).thenThrow(Exception());
      // Act
      final result = await repository.getUserProfile();
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ProfileFailure>()),
        (r) => fail('Should be Left'),
      );
      verify(() => mockDataSource.getUserProfile()).called(1);
    });
  });
}
