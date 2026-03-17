import 'package:flutter_test/flutter_test.dart';
import 'package:photo_app/features/photo/domain/models/index.dart'
    show PhotoItemModelDomain, PhotoModelDomain;
import 'package:photo_app/features/photo/presentation/mappers/index.dart'
    show PhotoModelDomainExtension;
import 'package:photo_app/features/photo/presentation/models/index.dart'
    show PhotoModelUI, PhotoItemModelUI;

void main() {
  group('PhotoModelDomainExtension -> toModelUi', () {
    late PhotoModelDomain domainWithPhotos;
    late PhotoModelDomain domainEmpty;
    late PhotoModelUI expectedWithPhotos;
    late PhotoModelUI expectedEmpty;

    setUp(() {
      final testItems = [
        PhotoItemModelDomain(
          path: '/storage/photo1.jpg',
          dateTime: DateTime(2025, 3, 17, 14, 30),
        ),
        PhotoItemModelDomain(
          path: '/storage/photo2.jpg',
          dateTime: DateTime(2025, 3, 16, 10, 15),
        ),
      ];

      domainWithPhotos = PhotoModelDomain(photosList: testItems);
      domainEmpty = const PhotoModelDomain(photosList: []);

      expectedWithPhotos = PhotoModelUI(
        photosList: testItems
            .map((e) => PhotoItemModelUI(path: e.path, dateTime: e.dateTime))
            .toList(),
      );
      expectedEmpty = const PhotoModelUI(photosList: []);
    });

    test('transforms domain model with photos into UI model', () {
      final result = domainWithPhotos.toModelUi();

      expect(result, isA<PhotoModelUI>());
      expect(result, equals(expectedWithPhotos));
    });

    test('transforms empty domain model into empty UI model', () {
      final result = domainEmpty.toModelUi();

      expect(result, isA<PhotoModelUI>());
      expect(result, equals(expectedEmpty));
    });
  });
}
