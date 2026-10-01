import 'package:equatable/equatable.dart';

import '../data/models/cause.dart';

enum CausesLoadStatus { loading, loaded, failed }

class CausesListState extends Equatable {
  const CausesListState({
    this.lang = 'en',
    this.status = CauseStatus.active,
    this.category,
    this.items = const [],
    this.page = 0,
    this.hasMore = false,
    this.loadStatus = CausesLoadStatus.loading,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final String lang;
  final CauseStatus status;
  final CauseCategory? category;
  final List<Cause> items;

  /// Last page loaded; 0 before the first one.
  final int page;
  final bool hasMore;
  final CausesLoadStatus loadStatus;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  CausesListState copyWith({
    String? lang,
    CauseStatus? status,
    CauseCategory? Function()? category,
    List<Cause>? items,
    int? page,
    bool? hasMore,
    CausesLoadStatus? loadStatus,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) {
    return CausesListState(
      lang: lang ?? this.lang,
      status: status ?? this.status,
      category: category != null ? category() : this.category,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      loadStatus: loadStatus ?? this.loadStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }

  @override
  List<Object?> get props => [
    lang,
    status,
    category,
    items,
    page,
    hasMore,
    loadStatus,
    isLoadingMore,
    loadMoreFailed,
  ];
}
