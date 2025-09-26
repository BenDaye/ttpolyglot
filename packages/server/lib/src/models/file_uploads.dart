/// 文件上传模型
class FileUpload {
  final String id;
  final String originalName;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final String filePath;
  final String? fileUrl;
  final String uploadType; // 'avatar', 'translation_file', 'attachment', etc.
  final String? entityType; // 'user', 'project', 'translation_entry', etc.
  final String? entityId;
  final String uploadedBy;
  final String storageType; // 'local', 's3', 'cloudinary', etc.
  final Map<String, dynamic>? metadata;
  final bool isPublic;
  final DateTime uploadedAt;
  final DateTime? expiresAt;

  FileUpload({
    required this.id,
    required this.originalName,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    required this.filePath,
    this.fileUrl,
    required this.uploadType,
    this.entityType,
    this.entityId,
    required this.uploadedBy,
    this.storageType = 'local',
    this.metadata,
    this.isPublic = false,
    required this.uploadedAt,
    this.expiresAt,
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) {
    return FileUpload(
      id: json['id'] as String,
      originalName: json['original_name'] as String,
      fileName: json['file_name'] as String,
      mimeType: json['mime_type'] as String,
      fileSize: json['file_size'] as int,
      filePath: json['file_path'] as String,
      fileUrl: json['file_url'] as String?,
      uploadType: json['upload_type'] as String,
      entityType: json['entity_type'] as String?,
      entityId: json['entity_id'] as String?,
      uploadedBy: json['uploaded_by'] as String,
      storageType: json['storage_type'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isPublic: json['is_public'] as bool? ?? false,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_name': originalName,
      'file_name': fileName,
      'mime_type': mimeType,
      'file_size': fileSize,
      'file_path': filePath,
      'file_url': fileUrl,
      'upload_type': uploadType,
      'entity_type': entityType,
      'entity_id': entityId,
      'uploaded_by': uploadedBy,
      'storage_type': storageType,
      'metadata': metadata,
      'is_public': isPublic,
      'uploaded_at': uploadedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  factory FileUpload.fromMap(Map<String, dynamic> map) {
    return FileUpload(
      id: map['id'] as String,
      originalName: map['original_name'] as String,
      fileName: map['file_name'] as String,
      mimeType: map['mime_type'] as String,
      fileSize: map['file_size'] as int,
      filePath: map['file_path'] as String,
      fileUrl: map['file_url'] as String?,
      uploadType: map['upload_type'] as String,
      entityType: map['entity_type'] as String?,
      entityId: map['entity_id'] as String?,
      uploadedBy: map['uploaded_by'] as String,
      storageType: map['storage_type'] as String,
      metadata: map['metadata'] as Map<String, dynamic>?,
      isPublic: map['is_public'] as bool,
      uploadedAt: map['uploaded_at'] as DateTime,
      expiresAt: map['expires_at'] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'original_name': originalName,
      'file_name': fileName,
      'mime_type': mimeType,
      'file_size': fileSize,
      'file_path': filePath,
      'file_url': fileUrl,
      'upload_type': uploadType,
      'entity_type': entityType,
      'entity_id': entityId,
      'uploaded_by': uploadedBy,
      'storage_type': storageType,
      'metadata': metadata,
      'is_public': isPublic,
      'uploaded_at': uploadedAt,
      'expires_at': expiresAt,
    };
  }

  /// 检查文件是否过期
  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  /// 获取文件大小的可读格式
  String get fileSizeFormatted {
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = fileSize.toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(size.truncateToDouble() == size ? 0 : 1)} ${units[unitIndex]}';
  }
}
