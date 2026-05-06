/// Base class for all database classes
///
/// provides a blueprint for basic CRUD operations
abstract class BaseDatabase {
  /// Initializes the database.
  ///
  /// This method must be called before any other methods can be used.
  Future<void> init();

  /// Inserts a row into the table.
  ///
  /// Parameters:
  /// - [tableName] : is the name of the table or box to save the value
  /// - [key] : is the key to save the value
  /// - [value] : is the value to save
  ///
  /// Returns a [Future] that completes with void when the operation is done.
  ///
  Future<void> save<T>({
    required String tableName,
    required String key,
    required T value,
  });

  /// Inserts all rows into the table.
  ///
  /// Parameters:
  /// - [tableName] : is the name of the table or box to save the value
  /// - [list] : is the list of values to save
  /// - [keys] : is the list of keys to save
  ///
  /// Returns a [Future] that completes with void when the operation is done.
  Future<void> saveAll<T>({
    required String tableName,
    required List<T>? list,
    required List<dynamic>? keys,
  });

  /// Retrieves the row with the given key.
  ///
  /// Parameters:
  /// - [tableName] : is the name of the table or box to retrieve the value
  /// - [key] : is the key to retrieve the value
  ///
  /// Returns a [Future] that completes with
  /// the value [T] when the operation is done.
  ///
  T? get<T>({
    required String tableName,
    required String key,
  });

  /// Retrieves all rows from the table.
  ///
  /// Parameters:
  /// - [tableName] : is the name of the table or box to retrieve the value
  ///
  /// Returns a [Future] that completes with
  /// the value [T] when the operation is done.
  ///
  List<T>? getAll<T>({
    required String tableName,
  });

  /// Deletes the row with the given key.
  ///
  /// Parameters:
  /// - [tableName] : is the name of the table or box to delete the value
  /// - [key] : is the key to delete the value
  ///
  /// Returns a [Future] that completes with void when the operation is done.
  Future<void> delete<T>({
    required String tableName,
    required String key,
  });

  /// Deletes all rows from the table.
  ///
  /// Parameters:
  /// - [tableName] : is the name of the table or box to be emptied
  ///
  /// Returns a [Future] that completes with void when the all rows are deleted.
  ///
  Future<int> clear({
    required String tableName,
  });

  Future<int> add<T>({
    required String tableName,
    required T data,
  });

  /// Updates an existing record in the table.
  ///
  /// [tableName] : The name of the table or box
  /// [key] : The key of the object to update
  /// [updateCallback] : A function that receives the current object [T]
  /// and returns an updated object [T]
  ///
  /// If the key does not exist, nothing will be updated.
  Future<void> update<T>({
    required String tableName,
    required String key,
    required T Function(T current) updateCallback,
  });
}
