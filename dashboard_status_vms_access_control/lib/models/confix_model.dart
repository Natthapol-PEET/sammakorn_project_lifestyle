class ConfixModel {
  final int? id;
  final String? page;

  const ConfixModel({
    this.id,
    this.page,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page': page,
    };
  }

  @override
  String toString() {
    return 'Account{id: $id, page: $page}';
  }
}
