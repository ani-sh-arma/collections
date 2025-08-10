I want to build a flutter app called Collections for "Chanda" collection for cultural events in my residancial area/ society.

Here's the requirements of the project
```
I want to build a mobile app for "chanda" collection for cultural events in my society.

I'm familiar with flutter and firebase so I'm thinking of using them for the tech stack.

I've got some features that I want in the app that I'm listing out here

1. in the home screen there will be cards in a list each card represents an event

2. in the cards there will be a random gradient color as bg, a title, date and any other important info about the events

3. On long press of the card there should appear an action menu for all the available actions with options like export, make a copy delete, etc.
4. also on the home screen top right corner there will be an import button onclick of which we can select a valid json file and import exported collections to the app

5. When clicked on a card another page opens where the basic details of the event will appear and then in a table format all the collection data will appear.


- Collection table will have 5 columns and 5 rows by default with an increment button for the columns and rows both.
- The first column will always be an auto incrementing serial number
- Second column is for room numbers
- Third column is for amount collected
- Fourth column will be a checkbox column for the online payment
- there should be a fifth/final column that represents addition and onclick of which another column should be added. This feature will always be there regardless of the number of columns
- Now as for the rows all the five rows will be empty rows for users to fill data with a final row that indicates additivity to add more rows
- after the data rows there should be a divider and after the divider there should be another table with three columns and three rows With column data such as "No.", "Source" and "Amount", and rows will be "(Serial number)", "Online/Offline/Total" and "Amount". Also these online/offline/total should be calculated automatically based on the collection table above and they will not be editable.



6. Every page will have its own lock button at the top right corner on tap of which everything will toggle as editable/uneditable aside from the total collection table (Which is always uneditable)
7. all the actions available for the cards in the home screen will also be available in this page on click of a more icon besides the editing toggle button.
8. I want all of the data to be realtime and update in the database as soon as i edit anything.
9. I want you to make another update so that I can reorder the rows and there should be a floating action button on the event details screen on click of which a new row will be inserted to the collection table and i should be able to add a row number here and the new row should be inserted there and the row which was there before and each row after that shall be moved to there "current index + 1".
10. Also on the home page there should be a similar floating action button on click of which a new event can be added
```

and below is an implementation plan for the project that I have come up with for now. I want you to go through with evrything and plan everything and suggest improvements for this project or the plan wherever you see fit and get ready to build this project

```
Collections — Implementation Plan (Offline / Local-first)

Local-first Chanda app using Flutter + BLoC. No Firebase. Includes autosave-on-edit, import/export (JSON), local persistence, locking, and totals computation.

1. High-level summary

All data is stored locally on the device and persisted immediately. The app uses BLoC for state management. Export/import uses a versioned JSON file so users can move data between devices manually (or via file share). The app supports autosave on every edit, soft-delete/undo, per-page lock toggle, and local backup files.

2. Tech stack (recommended)

Flutter (Dart)

State management: flutter_bloc (BLoC)

Local database: sqflite (SQLite) or Drift (recommended for type-safe queries)

Local file storage: path_provider + file_picker (import) + share_plus (export)

Optional lightweight key-value store: Hive for quick metadata (but keep table data in SQLite)

Packages: flutter_bloc, bloc, drift (or sqflite), path_provider, file_picker, share_plus, uuid, intl

Why Drift/SQLite?

A relational DB fits the table-like structure (events → rows → cells, columns schema) and supports transactions for schema changes.

Drift gives compile-time SQL safety and easy migrations.

3. Data model (local SQLite / Drift)

Tables

events
  id TEXT PRIMARY KEY
  title TEXT
  description TEXT
  date INTEGER   -- epoch millis
  locked INTEGER -- 0/1
  gradient_a TEXT
  gradient_b TEXT
  created_at INTEGER
  updated_at INTEGER

columns
  id TEXT PRIMARY KEY
  event_id TEXT FOREIGN KEY -> events.id
  key TEXT     -- semantic key, e.g., 'serial', 'room', 'amount', 'online', 'addcol', custom-uuid
  label TEXT
  type TEXT    -- 'serial','text','number','boolean','action'
  position INTEGER
  fixed INTEGER -- 0/1

rows
  id TEXT PRIMARY KEY
  event_id TEXT FOREIGN KEY -> events.id
  position INTEGER -- 1-based index
  created_at INTEGER
  updated_at INTEGER

cells
  id TEXT PRIMARY KEY
  row_id TEXT FOREIGN KEY -> rows.id
  column_id TEXT FOREIGN KEY -> columns.id
  value_text TEXT
  value_number REAL
  value_bool INTEGER -- 0/1

Totals

event_totals table or computed on demand by summing cells where column.key == 'amount' and cells where online flag is set. Totals are computed locally whenever rows change and written to a small event_totals cache table for fast reads.

Rationale

Normalized schema avoids wide rows and makes it easy to add/remove columns dynamically.

Using position keeps serial stable; reindexing is done carefully when rows are deleted.

4. App architecture with BLoC

Feature-based structure: features/events, features/event_detail, core/db, core/models, core/utils.

Each screen has its own BLoC:

EventsBloc — manages list of events (create/copy/delete/import/export)

EventDetailBloc — manages single event state: columns, rows, cells, lock toggle, add/remove column/row, autosave

ImportExportCubit — handles import/export validation and progress

BLoCs interact with a repository layer (EventRepository) that exposes async methods backed by Drift/SQLite. Repositories handle transactions and file IO.

5. Autosave & write strategy

Requirement: autosave on every edit.

Implementation approach:

For every cell edit (text/number/checkbox), immediately persist the change in a single SQL INSERT/UPDATE for that cell row. This guarantees durability.

For text inputs, to avoid huge write churn on each keystroke while still honoring "autosave": use a very short debounce (200–300ms) for onChanged writes, and also write on onEditingComplete/focus loss. This keeps the feeling of immediate autosave while avoiding writing dozens of times a second.

For checkbox toggles and numeric fields, write immediately (these are cheap).

Use transactions for multi-step schema changes (add/remove column) to keep DB consistent.

Optimistic UI:

Update UI immediately before DB write completes. If write fails (rare for local DB), show a SnackBar and retry or rollback.

Write queue & durability:

Writes are local and fast; but implement a simple retry queue for rare IO errors (e.g., storage full). The queue persists pending operations to a small pending_ops table so app can resume after crash.

6. UI differences for offline-first

Mostly the UI remains the same as the online plan with these adjustments:

Event cards still have gradients, title, date. Gradients are stored in the events table so they persist.

Long-press shows action sheet (Export, Make a Copy, Delete, Rename, Lock/Unlock).

Import button opens FilePicker and shows a preview before importing.

Lock toggle updates locked in events table and the BLoC enforces editability — the DB schema doesn't prevent writes but UI blocks editing when locked.

Totals card is computed locally and shown immediately after each change.

7. Totals calculation (local)

Totals are computed by the EventDetailBloc whenever a relevant cell changes.

Implementation: query all rows' amount cells and online flags; compute online, offline, and total sums in Dart; write computed totals to event_totals table (or keep in-memory if you prefer).

Use transactions when computing totals as part of add/remove row/column operations to maintain consistency.

8. Import / Export JSON spec (local-first)

Keep the same versioned JSON format as the original plan. Example structure remains compatible.

Export flow

Read event, columns, rows, and cells from the local DB and construct the export JSON object.

Write JSON string to a file in app documents or cache directory (use path_provider), then call share_plus to let the user save/share.

Optionally keep a local backups/ folder with timestamped exports (configurable in settings).

Import flow

Pick file with file_picker.

Validate JSON version and schema.

Present a preview screen showing event title, columns, and row count. User confirms.

Use a DB transaction to insert event, columns, rows, and cells. Generate new UUIDs to avoid key collisions.

If title conflicts, append " (imported)".

Merge option (advanced)

Optionally provide a merge import: merge incoming rows into an existing event (match by room number if provided) — this is an advanced feature and can be added later.

9. Locking & editability

locked is a boolean on the events table.

UI and BLoC respect locked and prevent edits; destructive actions (delete) still show confirmation.

Consider a passphrase option to prevent accidental unlock — store hashed passphrase in local secure storage (optional).

10. Undo / soft-delete

When deleting an event or a row, move it to a trash table with deleted_at. Provide a Trash screen where users can restore within a retention window (configurable, e.g., 30 days) or permanently delete.

For quick undo (row deleted), show a SnackBar with Undo for ~6s and restore the row if undone.
```
