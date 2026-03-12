import '../../domain/models/index.dart' show PhotoModelDomain;
import '../models/index.dart' show PhotoModelUI, PhotoItemModelUI;

extension PhotoModelDomainExtension on PhotoModelDomain {
  PhotoModelUI toModelUi() {
    final photosList = this.photosList
        .map((e) => PhotoItemModelUI(path: e.path, dateTime: e.dateTime))
        .toList();
    return PhotoModelUI(photosList: photosList);
  }
}
