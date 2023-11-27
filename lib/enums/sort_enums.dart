enum SortType {
  name,
  date,
  //todo: add location
}

String sortTypeDisplayName(SortType sortType) {
  switch (sortType) {
    case SortType.name:
      return "nazwy";
    case SortType.date:
      return "daty";
  }
}

enum SortOrder {
  ascending,
  descending,
}

String sortOrderDisplayName(SortOrder sortOrder) {
  switch (sortOrder) {
    case SortOrder.ascending:
      return "rosnąca";
    case SortOrder.descending:
      return "malejąca";
  }
}
