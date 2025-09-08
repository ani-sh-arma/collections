class AppConstants {
  // App Information
  static const String appName = 'Collections';
  static const String appDescription = 'Chanda collection app for cultural events';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'collections.db';
  static const int databaseVersion = 1;

  // Export/Import
  static const String exportVersion = '1.0.0';
  static const String exportFileExtension = '.json';
  static const int maxBackupFiles = 10;

  // UI Constants
  static const int defaultRowCount = 5;
  static const int defaultColumnCount = 5;
  static const double cardElevation = 4.0;
  static const double borderRadius = 12.0;
  static const double padding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Autosave
  static const Duration autosaveDelay = Duration(milliseconds: 300);
  static const Duration immediateDelay = Duration(milliseconds: 50);

  // Animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Default Column Keys
  static const String serialColumnKey = 'serial';
  static const String roomColumnKey = 'room';
  static const String amountColumnKey = 'amount';
  static const String onlineColumnKey = 'online';
  static const String addColumnKey = 'addcol';

  // Default Column Labels
  static const String serialColumnLabel = 'No.';
  static const String roomColumnLabel = 'Room';
  static const String amountColumnLabel = 'Amount';
  static const String onlineColumnLabel = 'Online';
  static const String addColumnLabel = '+';

  // Totals Labels
  static const String onlineTotalLabel = 'Online';
  static const String offlineTotalLabel = 'Offline';
  static const String grandTotalLabel = 'Total';

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String importErrorMessage = 'Failed to import file. Please check the file format.';
  static const String exportErrorMessage = 'Failed to export data. Please try again.';
  static const String saveErrorMessage = 'Failed to save changes. Please try again.';
  static const String deleteErrorMessage = 'Failed to delete item. Please try again.';

  // Success Messages
  static const String saveSuccessMessage = 'Changes saved successfully.';
  static const String exportSuccessMessage = 'Data exported successfully.';
  static const String importSuccessMessage = 'Data imported successfully.';
  static const String deleteSuccessMessage = 'Item deleted successfully.';

  // Confirmation Messages
  static const String deleteEventConfirmation = 'Are you sure you want to delete this event? This action cannot be undone.';
  static const String deleteRowConfirmation = 'Are you sure you want to delete this row?';
  static const String deleteColumnConfirmation = 'Are you sure you want to delete this column?';
  static const String clearAllDataConfirmation = 'Are you sure you want to clear all data? This action cannot be undone.';

  // Validation
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxRoomNumberLength = 20;
  static const double maxAmountValue = 999999.99;
  static const int maxRowsPerEvent = 1000;
  static const int maxColumnsPerEvent = 50;

  // File Picker
  static const List<String> allowedFileExtensions = ['json'];
  static const String filePickerTitle = 'Select Collections Export File';

  // Share
  static const String shareSubject = 'Collections Export';
  static const String shareText = 'Collections data export';

  // Lock/Unlock
  static const String lockTooltip = 'Lock editing';
  static const String unlockTooltip = 'Unlock editing';
  static const String lockedMessage = 'This event is locked. Tap the lock icon to enable editing.';

  // Empty States
  static const String noEventsMessage = 'No events yet. Tap the + button to create your first event.';
  static const String noDataMessage = 'No data available.';
  static const String emptyTableMessage = 'Start adding data to your collection table.';

  // Loading States
  static const String loadingMessage = 'Loading...';
  static const String savingMessage = 'Saving...';
  static const String exportingMessage = 'Exporting...';
  static const String importingMessage = 'Importing...';
}
