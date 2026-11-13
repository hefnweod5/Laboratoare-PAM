/// Opțiunile de sortare expuse utilizatorului.
///
/// Sortarea este făcută pe server prin parametrii `sortBy` și `order`.
enum ArticleSort {
  newest('Cele mai noi', null, null),
  mostViewed('Cele mai citite', 'views', 'desc'),
  titleAsc('Titlu A-Z', 'title', 'asc'),
  titleDesc('Titlu Z-A', 'title', 'desc');

  const ArticleSort(this.label, this.sortBy, this.order);

  final String label;
  final String? sortBy;
  final String? order;
}
