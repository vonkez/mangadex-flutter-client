import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:md_fclient/network/manga_search_filter.dart';
import 'package:md_fclient/ui/home_controller.dart';
import 'package:md_fclient/ui/manga_search_controller.dart';
import 'package:get/get.dart';

import 'manga_details.dart';
import 'network_image_hero.dart';

class MangaSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return _buildSheet();
              }).whenComplete(() => MangaSearchController.to.search());
        },
      ),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    MangaSearchController.to.query.value = query;
    return _buildMangas(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    MangaSearchController.to.query.value = query;
    return _buildMangas(context);
  }

  Widget _buildMangas(BuildContext context) {
    return Obx(() {
      return ListView(
        children: [
          for (var manga in MangaSearchController.to.suggestions)
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
                  return MangaDetails(manga: manga);
                }));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NetworkImageHero(
                      imageUrl: manga.coverUrl,
                      width: 80,
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Text(
                          manga.title,
                          style: const TextStyle(fontSize: 20),
                        )),
                        if (manga.status != null) Chip(label: Text(manga.status!))
                      ],
                    ),
                  ),
                ],
              ),
            )
        ],
      );
    });
  }

  Widget _buildSheet() {
    return Container(
        height: 700,
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    tooltip: "Reset",
                    onPressed: () {
                      MangaSearchController.to.demographic.clear();
                      MangaSearchController.to.status.clear();
                      MangaSearchController.to.contentRating.clear();
                    },
                    icon: Icon(Icons.replay))
              ],
            ),
            ..._buildDemographicFilters(),
            ..._buildStatusFilters(),
            ..._buildContentRatingFilters(),
          ],
        ));
  }

  List<Widget> _buildDemographicFilters() {
    return [
      const Padding(
        padding: EdgeInsets.only(bottom: 6.0, top: 12.0),
        child: Text(
          "Demographic",
          style: TextStyle(fontSize: 18),
        ),
      ),
      Obx(() {
        return Wrap(
          spacing: 6,
          children: [
            for (var e in Demographic.values)
              FilterChip(
                label: Text(describeEnum(e).capitalizeFirst!),
                visualDensity: const VisualDensity(horizontal: 0.0, vertical: -1),
                selected: MangaSearchController.to.demographic.contains(e),
                onSelected: (bool value) {
                  if (value) {
                    MangaSearchController.to.demographic.add(e);
                  } else {
                    MangaSearchController.to.demographic.remove(e);
                  }
                },
              ),
            FilterChip(
              label: const Text("Any"),
              visualDensity: const VisualDensity(horizontal: 0.0, vertical: -1),
              selected: MangaSearchController.to.demographic.isEmpty,
              onSelected: (bool value) {
                if (MangaSearchController.to.demographic.isNotEmpty) {
                  MangaSearchController.to.demographic.clear();
                }
              },
            )
          ],
        );
      }),
    ];
  }

  List<Widget> _buildStatusFilters() {
    return [
      const Padding(
        padding: EdgeInsets.only(bottom: 6.0, top: 12.0),
        child: Text(
          "Publication Status",
          style: TextStyle(fontSize: 18),
        ),
      ),
      Obx(() {
        return Wrap(
          spacing: 6,
          children: [
            for (var e in Status.values)
              FilterChip(
                label: Text(describeEnum(e).capitalizeFirst!),
                visualDensity: const VisualDensity(horizontal: 0.0, vertical: -1),
                selected: MangaSearchController.to.status.contains(e),
                onSelected: (bool value) {
                  if (value) {
                    MangaSearchController.to.status.add(e);
                  } else {
                    MangaSearchController.to.status.remove(e);
                  }
                },
              ),
            FilterChip(
              label: const Text("Any"),
              visualDensity: const VisualDensity(horizontal: 0.0, vertical: -1),
              selected: MangaSearchController.to.status.isEmpty,
              onSelected: (bool value) {
                if (MangaSearchController.to.status.isNotEmpty) {
                  MangaSearchController.to.status.clear();
                }
              },
            )
          ],
        );
      }),
    ];
  }

  List<Widget> _buildContentRatingFilters() {
    return [
      const Padding(
        padding: EdgeInsets.only(bottom: 6.0, top: 12.0),
        child: Text(
          "Content Rating",
          style: TextStyle(fontSize: 18),
        ),
      ),
      Obx(() {
        return Wrap(
          spacing: 6,
          children: [
            for (var e in ContentRating.values)
              FilterChip(
                label: Text(describeEnum(e).capitalizeFirst!),
                visualDensity: const VisualDensity(horizontal: 0.0, vertical: -1),
                selected: MangaSearchController.to.contentRating.contains(e),
                onSelected: (bool value) {
                  if (value) {
                    MangaSearchController.to.contentRating.add(e);
                  } else {
                    MangaSearchController.to.contentRating.remove(e);
                  }
                },
              ),
            FilterChip(
              label: const Text("Any"),
              visualDensity: const VisualDensity(horizontal: 0.0, vertical: -1),
              selected: MangaSearchController.to.contentRating.isEmpty,
              onSelected: (bool value) {
                if (MangaSearchController.to.contentRating.isNotEmpty) {
                  MangaSearchController.to.contentRating.clear();
                }
              },
            )
          ],
        );
      }),
    ];
  }
}
