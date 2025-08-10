import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../../../core/repositories/event_repository.dart';
import '../../../core/utils/file_utils.dart';
import '../../../core/constants/app_constants.dart';
import 'import_export_state.dart';

class ImportExportCubit extends Cubit<ImportExportState> {
  final EventRepository _repository;

  ImportExportCubit({required EventRepository repository})
      : _repository = repository,
        super(const ImportExportInitial());

  /// Exports all events to a JSON file and shares it
  Future<void> exportAllEvents() async {
    try {
      emit(const ImportExportLoading('Exporting all events'));
      
      final events = await _repository.getAllEvents();
      if (events.isEmpty) {
        emit(const ImportExportError('No events to export'));
        return;
      }

      final eventIds = events.map((e) => e.id).toList();
      final exportData = await _repository.exportEvents(eventIds);
      
      await FileUtils.exportAndShare(exportData);
      
      // Also create a local backup
      await FileUtils.createBackup(exportData);
      
      emit(ExportSuccess(
        'Successfully exported ${events.length} event(s)',
      ));
    } catch (e) {
      emit(ImportExportError('Export failed: ${e.toString()}'));
    }
  }

  /// Exports specific events to a JSON file and shares it
  Future<void> exportEvents(List<String> eventIds) async {
    try {
      emit(const ImportExportLoading('Exporting selected events'));
      
      if (eventIds.isEmpty) {
        emit(const ImportExportError('No events selected for export'));
        return;
      }

      final exportData = await _repository.exportEvents(eventIds);
      
      if (exportData.events.isEmpty) {
        emit(const ImportExportError('No valid events found to export'));
        return;
      }
      
      await FileUtils.exportAndShare(exportData);
      
      // Also create a local backup
      await FileUtils.createBackup(exportData);
      
      emit(ExportSuccess(
        'Successfully exported ${exportData.events.length} event(s)',
      ));
    } catch (e) {
      emit(ImportExportError('Export failed: ${e.toString()}'));
    }
  }

  /// Exports a single event to a JSON file and shares it
  Future<void> exportSingleEvent(String eventId) async {
    await exportEvents([eventId]);
  }

  /// Picks a file and shows import preview
  Future<void> pickFileForImport() async {
    try {
      emit(const ImportExportLoading('Loading file'));
      
      final exportData = await FileUtils.pickAndImportFile();
      
      if (exportData == null) {
        emit(const ImportExportInitial()); // User cancelled
        return;
      }

      // Validate the export data
      if (exportData.events.isEmpty) {
        emit(const ImportExportError('The selected file contains no events'));
        return;
      }

      // Generate preview
      final preview = FileUtils.getExportPreview(exportData);
      
      emit(ImportPreview(
        exportData: exportData,
        preview: preview,
      ));
    } catch (e) {
      emit(ImportExportError('Failed to load file: ${e.toString()}'));
    }
  }

  /// Confirms and executes the import
  Future<void> confirmImport(ExportData exportData) async {
    try {
      emit(const ImportExportLoading('Importing events'));
      
      final importedEventIds = await _repository.importEvents(exportData);
      
      if (importedEventIds.isEmpty) {
        emit(const ImportExportError('No events were imported'));
        return;
      }

      emit(ImportSuccess(
        'Successfully imported ${importedEventIds.length} event(s)',
        importedEventIds,
      ));
    } catch (e) {
      emit(ImportExportError('Import failed: ${e.toString()}'));
    }
  }

  /// Cancels the current import preview
  void cancelImport() {
    emit(const ImportExportInitial());
  }

  /// Creates a backup of all current data
  Future<void> createBackup() async {
    try {
      emit(const ImportExportLoading('Creating backup'));
      
      final events = await _repository.getAllEvents();
      if (events.isEmpty) {
        emit(const ImportExportError('No data to backup'));
        return;
      }

      final eventIds = events.map((e) => e.id).toList();
      final exportData = await _repository.exportEvents(eventIds);
      
      final backupFile = await FileUtils.createBackup(exportData);
      
      // Clean up old backups
      await FileUtils.cleanupOldBackups(keepCount: AppConstants.maxBackupFiles);
      
      emit(ExportSuccess(
        'Backup created successfully',
        filePath: backupFile.path,
      ));
    } catch (e) {
      emit(ImportExportError('Backup failed: ${e.toString()}'));
    }
  }

  /// Validates a file path for import
  Future<void> validateImportFile(String filePath) async {
    try {
      emit(const ImportExportLoading('Validating file'));
      
      final isValid = await FileUtils.validateExportFile(filePath);
      
      if (!isValid) {
        emit(FileValidationError(
          'The selected file is not a valid Collections export file',
          filePath: filePath,
        ));
        return;
      }

      emit(const ImportExportInitial());
    } catch (e) {
      emit(FileValidationError(
        'Failed to validate file: ${e.toString()}',
        filePath: filePath,
      ));
    }
  }

  /// Resets the cubit to initial state
  void reset() {
    emit(const ImportExportInitial());
  }
}
