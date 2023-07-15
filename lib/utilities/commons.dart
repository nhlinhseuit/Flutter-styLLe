List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
  final chunks = <List<T>>[];

  for (var i = 0; i < list.length; i += chunkSize) {
    final end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
    chunks.add(list.sublist(i, end));
  }

  return chunks;
}