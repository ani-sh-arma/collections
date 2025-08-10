import 'package:equatable/equatable.dart';
import '../../../core/models/models.dart';

abstract class ImportExportState extends Equatable {
  const ImportExportState();

  @override
  List<Object?> get props => [];
}

class ImportExportInitial extends ImportExportState {
  const ImportExportInitial();
}

class ImportExportLoading extends ImportExportState {
  final String operation;

  const ImportExportLoading(this.operation);

  @override
  List<Object?> get props => [operation];
}

class ExportSuccess extends ImportExportState {
  final String message;
  final String? filePath;

  const ExportSuccess(this.message, {this.filePath});

  @override
  List<Object?> get props => [message, filePath];
}

class ImportPreview extends ImportExportState {
  final ExportData exportData;
  final Map<String, dynamic> preview;

  const ImportPreview({
    required this.exportData,
    required this.preview,
  });

  @override
  List<Object?> get props => [exportData, preview];
}

class ImportSuccess extends ImportExportState {
  final String message;
  final List<String> importedEventIds;

  const ImportSuccess(this.message, this.importedEventIds);

  @override
  List<Object?> get props => [message, importedEventIds];
}

class ImportExportError extends ImportExportState {
  final String message;

  const ImportExportError(this.message);

  @override
  List<Object?> get props => [message];
}

class FileValidationError extends ImportExportState {
  final String message;
  final String? filePath;

  const FileValidationError(this.message, {this.filePath});

  @override
  List<Object?> get props => [message, filePath];
}
