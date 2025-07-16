import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';

class ExpansionPanelListItem {
  Language language;
  List<TranslationEntry> entries;
  bool isExpanded;

  ExpansionPanelListItem({
    required this.language,
    required this.entries,
    this.isExpanded = false,
  });
}

// TODO: 还是做成 Getx 来控制数据， 不然每次改变都会触发重新渲染整个组件，不友好
class TranslationsCardByLanguageExpansionPanelList extends StatefulWidget {
  const TranslationsCardByLanguageExpansionPanelList({
    super.key,
    required this.groupedEntries,
    this.onDeleteAllEntries,
    this.onEditEntry,
  });

  final Map<Language, List<TranslationEntry>> groupedEntries;
  final Function({
    required String key,
    required List<TranslationEntry> entries,
  })? onDeleteAllEntries;
  final Function({
    required TranslationEntry entry,
  })? onEditEntry;

  @override
  State<TranslationsCardByLanguageExpansionPanelList> createState() =>
      _TranslationsCardByLanguageExpansionPanelListState();
}

class _TranslationsCardByLanguageExpansionPanelListState extends State<TranslationsCardByLanguageExpansionPanelList> {
  final List<ExpansionPanelListItem> _expansionPanelListItems = [];

  @override
  void initState() {
    super.initState();
    _updateExpansionPanelItems();
  }

  @override
  void didUpdateWidget(TranslationsCardByLanguageExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.groupedEntries != widget.groupedEntries) {
      _updateExpansionPanelItems();
    }
  }

  void _updateExpansionPanelItems() {
    _expansionPanelListItems.clear();
    _expansionPanelListItems.addAll(
      widget.groupedEntries.entries.map(
        (entry) => ExpansionPanelListItem(language: entry.key, entries: entry.value, isExpanded: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _expansionPanelListItems[panelIndex].isExpanded = !_expansionPanelListItems[panelIndex].isExpanded;
        });
      },
      children: [
        ..._expansionPanelListItems.map(
          (item) {
            return ExpansionPanel(
              isExpanded: item.isExpanded,
              canTapOnHeader: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              headerBuilder: (context, isExpanded) {
                return TranslationsCardByLanguageHeader(
                  language: item.language,
                  translationEntries: item.entries,
                );
              },
              body: TranslationsCardByLanguageBody(
                language: item.language,
                translationEntries: item.entries,
                onDeleteAllEntries: widget.onDeleteAllEntries,
                onEditEntry: widget.onEditEntry,
              ),
            );
          },
        ),
      ],
    );
  }
}

class TranslationsCardByLanguageHeader extends StatelessWidget {
  const TranslationsCardByLanguageHeader({
    super.key,
    required this.language,
    required this.translationEntries,
    this.onDeleteAllEntries,
    this.onEditEntry,
  });

  final Language language;
  final List<TranslationEntry> translationEntries;
  final Function({
    required String key,
    required List<TranslationEntry> entries,
  })? onDeleteAllEntries;
  final Function({
    required TranslationEntry entry,
  })? onEditEntry;

  @override
  Widget build(BuildContext context) {
    final bool isSourceLanguage = language.code == translationEntries.first.sourceLanguage.code;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部信息
          Row(
            children: [
              // 语言标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  language.code,
                  style: GoogleFonts.notoSansMono(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              // 语言
              // 语言信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.nativeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isSourceLanguage ? Theme.of(context).colorScheme.primary : null,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${language.name} (${language.code})',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                isSourceLanguage ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.7) : null,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TranslationsCardByLanguageBody extends StatelessWidget {
  const TranslationsCardByLanguageBody({
    super.key,
    required this.language,
    required this.translationEntries,
    this.onDeleteAllEntries,
    this.onEditEntry,
  });

  final Language language;
  final List<TranslationEntry> translationEntries;
  final Function({
    required String key,
    required List<TranslationEntry> entries,
  })? onDeleteAllEntries;
  final Function({
    required TranslationEntry entry,
  })? onEditEntry;

  @override
  Widget build(BuildContext context) {
    final bool isSourceLanguage = language.code == translationEntries.first.sourceLanguage.code;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      constraints: const BoxConstraints(
        maxHeight: 480.0,
      ),
      child: ListView.builder(
        itemCount: translationEntries.length,
        itemBuilder: (context, index) {
          final entry = translationEntries[index];
          return Card(
            color: isSourceLanguage
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainer,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              onTap: isSourceLanguage ? null : () => onEditEntry?.call(entry: entry),
              leading: // 状态标签
                  Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: TranslationController.getStatusColor(entry.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  entry.status.displayName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TranslationController.getStatusColor(entry.status),
                        fontSize: 10.0,
                      ),
                ),
              ),
              title: Text(
                entry.key,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              subtitle: Text(
                entry.targetText.isEmpty ? '待翻译' : entry.targetText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: entry.targetText.isEmpty
                          ? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                          : null,
                      fontStyle: entry.targetText.isEmpty ? FontStyle.italic : null,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
