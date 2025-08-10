import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';

class FileUtils {
  static const String _backupFolderName = 'backups';
  static const String _exportFileExtension = '.json';

  /// Gets the app's documents directory
  static Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Gets or creates the backups directory
  static Future<Directory> getBackupsDirectory() async {
    final appDir = await getAppDocumentsDirectory();
    final backupsDir = Directory('${appDir.path}/$_backupFolderName');
    
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }
    
    return backupsDir;
  }

  /// Generates a filename for export with timestamp
  static String generateExportFilename({String? prefix}) {
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final prefixPart = prefix != null ? '${prefix}_' : '';
    return '${prefixPart}collections_export_$timestamp$_exportFileExtension';
  }

  /// Exports data to a JSON file and shares it
  static Future<void> exportAndShare(ExportData exportData, {String? filename}) async {
    try {
      final jsonString = jsonEncode(exportData.toJson());
      final fileName = filename ?? generateExportFilename();
      
      // Create temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonString);
      
      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Collections Export - ${exportData.events.length} event(s)',
        subject: 'Collections Export',
      );
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  /// Creates a local backup of the export data
  static Future<File> createBackup(ExportData exportData, {String? filename}) async {
    try {
      final jsonString = jsonEncode(exportData.toJson());
      final fileName = filename ?? generateExportFilename(prefix: 'backup');
      
      final backupsDir = await getBackupsDirectory();
      final file = File('${backupsDir.path}/$fileName');
      await file.writeAsString(jsonString);
      
      return file;
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  /// Picks and imports a JSON file
  static Future<ExportData?> pickAndImportFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        
        return ExportData.fromJson(jsonData);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to import file: $e');
    }
  }

  /// Validates if a JSON file is a valid Collections export
  static Future<bool> validateExportFile(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Check for required fields
      if (!jsonData.containsKey('version') || 
          !jsonData.containsKey('exportedAt') || 
          !jsonData.containsKey('events')) {
        return false;
      }
      
      // Try to parse as ExportData
      ExportData.fromJson(jsonData);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all backup files sorted by creation date (newest first)
  static Future<List<File>> getBackupFiles() async {
    try {
      final backupsDir = await getBackupsDirectory();
      final files = backupsDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith(_exportFileExtension))
          .toList();
      
      // Sort by modification date (newest first)
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      
      return files;
    } catch (e) {
      return [];
    }
  }

  /// Deletes old backup files, keeping only the specified number
  static Future<void> cleanupOldBackups({int keepCount = 10}) async {
    try {
      final backupFiles = await getBackupFiles();
      
      if (backupFiles.length > keepCount) {
        final filesToDelete = backupFiles.skip(keepCount);
        for (final file in filesToDelete) {
          await file.delete();
        }
      }
    } catch (e) {
      // Silently fail - cleanup is not critical
    }
  }

  /// Gets the size of a file in a human-readable format
  static String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Gets a preview of export data for display
  static Map<String, dynamic> getExportPreview(ExportData exportData) {
    final totalEvents = exportData.events.length;
    final totalRows = exportData.events
        .map((e) => e.rows.length)
        .fold(0, (sum, count) => sum + count);
    final totalCells = exportData.events
        .map((e) => e.cells.length)
        .fold(0, (sum, count) => sum + count);
    
    return {
      'version': exportData.version,
      'exportedAt': exportData.exportedAt,
      'totalEvents': totalEvents,
      'totalRows': totalRows,
      'totalCells': totalCells,
      'eventTitles': exportData.events.map((e) => e.event.title).toList(),
    };
  }
}
