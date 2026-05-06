import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BaseDatabase)
class HiveDatabaseClient implements BaseDatabase {
  @override
  Future<void> init() async {
    await Hive.initFlutter();

    // region register adapters

    // endregion

    // region open boxes
    await Hive.openBox<String>(DatabaseConstants.userDataTable);
    await Hive.openBox<int>(DatabaseConstants.userRewardsTable);

    // endregion
  }

  @override
  Future<void> save<T>({
    required String tableName,
    required String key,
    required T value,
  }) async {
    final Box<T> box = Hive.box<T>(tableName);
    return box.put(key, value);
  }

  @override
  Future<void> saveAll<T>({
    required String tableName,
    required List<T>? list,
    required List<dynamic>? keys,
  }) async {
    if (list != null && keys != null && list.length == keys.length) {
      final Box<T> box = Hive.box<T>(tableName);
      for (int i = 0; i < list.length; i++) {
        await box.put(keys[i], list[i]);
      }
    }
  }

  @override
  T? get<T>({
    required String tableName,
    required String key,
  }) {
    final Box<T> box = Hive.box<T>(tableName);
    return box.get(key);
  }

  @override
  List<T>? getAll<T>({
    required String tableName,
  }) {
    final Box<T> box = Hive.box<T>(tableName);
    return box.values.toList();
  }

  @override
  Future<void> delete<T>({
    required String tableName,
    required String key,
  }) async {
    final Box<T> box = Hive.box<T>(tableName);
    return box.delete(key);
  }

  @override
  Future<int> clear({
    required String tableName,
  }) async {
    final Box<dynamic> box = Hive.box(tableName);
    return box.clear();
  }

  @override
  Future<int> add<T>({required String tableName, required T data}) {
    final Box<T> box = Hive.box<T>(tableName);
    return box.add(data); // Perform type casting to match the type of the box
  }

  @override
  Future<void> update<T>({
    required String tableName,
    required String key,
    required T Function(T current) updateCallback,
  }) async {
    final Box<T> box = Hive.box<T>(tableName);
    final T? current = box.get(key);

    if (current != null) {
      final T updated = updateCallback(current);
      await box.put(key, updated);
    }
  }
}
