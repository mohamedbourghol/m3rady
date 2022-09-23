/// Set media types
enum MediaType {
  image,
  video,
  audio,
  file,
}

class Media {
  int id;
  String? uuid;
  int? order;
  String mediaUrl;
  String? thumbnailImageUrl;
  String? downloadUrl;
  MediaType type;
  String? fileName;
  String? mimeType;
  String? size;
  int? width;
  int? height;
  bool? isVoiceNote = false;

  Media({
    required this.id,
    this.uuid,
    this.order,
    this.thumbnailImageUrl,
    required this.mediaUrl,
    this.downloadUrl,
    required this.type,
    this.fileName,
    this.mimeType,
    this.size,
     this.width,
     this.height,
    this.isVoiceNote,
  });

  /// Factory
  factory Media.fromJson(Map<String, dynamic> data) {
    return Media(
      id: data['id'] as int,
      uuid: data['uuid'],
      order: (data['order'] ?? 0) as int,
      mediaUrl: data['mediaUrl'] as String,
      downloadUrl: data['downloadUrl'] as String,
      thumbnailImageUrl: (data['thumbnailImageUrl']),
      type: data['type'] == 'video' ? MediaType.video : MediaType.image,
      fileName: data['fileName'],
      mimeType: data['mimeType'],
      size: data['size'],
      width: data['width'] ?? 1024,
      height: data['height'] ?? 768,
      isVoiceNote: data['isVoiceNote'],
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Media.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }
}
