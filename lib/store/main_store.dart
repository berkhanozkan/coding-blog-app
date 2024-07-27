abstract class IMainStore<T> {
  Future<void> update(T item);
  Future<void> delete(String id);
  Future<void> create(T item);
  Future<T> get(String id);
  Future<List<T>> getAll();
}
