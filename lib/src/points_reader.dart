part of drtree_benchmark;

class PointsReader {
  final FileReader _reader = FileReader();

  Future<BenchmarkPoints> read(String path) async {
    final json = await _reader.readAsJson(path) as Map<String, Object?>;

    return BenchmarkPoints.fromJson(json);
  }
}
