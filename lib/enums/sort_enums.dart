enum SortType {
  name,
  date,
  //todo: add location
}

extension SortTypeDisplay on SortType {
  String get displayName {
    return switch (this) {
      SortType.name => "nazwy",
      SortType.date => "daty",
    };
  }
}

enum SortOrder {
  ascending,
  descending,
}

extension SortOrderDisplay on SortOrder {
  String get displayName {
    return switch (this) {
      SortOrder.ascending => "rosnąca",
      SortOrder.descending => "malejąca"
    };
  }
}
