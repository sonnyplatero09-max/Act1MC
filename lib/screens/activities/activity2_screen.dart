import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';

/// Activity 2: Smart Bill & Tip Splitter Calculator
///
/// Demonstrates [StatefulWidget] for interactive form and calculation logic:
/// - [TextEditingController] for real-time input listening
/// - Local reactive calculations with [setState]
/// - Responsive layout using [Row], [Column], [Expanded], [Card]
class Activity2Screen extends StatefulWidget {
  static const String routeName = '/activity2';

  const Activity2Screen({super.key});

  @override
  State<Activity2Screen> createState() => _Activity2ScreenState();
}

class _Activity2ScreenState extends State<Activity2Screen> {
  final TextEditingController _billController = TextEditingController(text: '1250.00');
  double _tipPercentage = 10.0;
  int _splitCount = 3;

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  double get _billAmount {
    return double.tryParse(_billController.text.trim()) ?? 0.0;
  }

  double get _tipTotal => (_billAmount * _tipPercentage) / 100.0;
  double get _grandTotal => _billAmount + _tipTotal;
  double get _perPersonTotal => _splitCount > 0 ? _grandTotal / _splitCount : 0.0;
  double get _perPersonTip => _splitCount > 0 ? _tipTotal / _splitCount : 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateProvider>();
    final isCompleted = appState.isActivityCompleted('act-2');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 2: Split Calculator'),
        actions: [
          IconButton(
            tooltip: isCompleted ? 'Mark as Incomplete' : 'Mark as Completed',
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: isCompleted ? Colors.green : null,
            ),
            onPressed: () {
              appState.toggleActivityCompleted('act-2');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isCompleted
                        ? 'Activity 2 marked incomplete'
                        : 'Activity 2 marked as Completed!',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Result Summary Highlight Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'TOTAL PER PERSON',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₱${_perPersonTotal.toStringAsFixed(2)}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(height: 12),
                    // Responsive Summary Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                          label: 'Total Bill',
                          value: '₱${_grandTotal.toStringAsFixed(2)}',
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        _buildSummaryItem(
                          label: 'Total Tip',
                          value: '₱${_tipTotal.toStringAsFixed(2)}',
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        _buildSummaryItem(
                          label: 'Tip / Person',
                          value: '₱${_perPersonTip.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input: Bill Amount
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Bill Amount',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _billController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.receipt_long),
                          prefixText: '₱ ',
                          hintText: '0.00',
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: _billController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _billController.clear();
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Input: Tip Percentage Slider
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tip Percentage',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_tipPercentage.toInt()}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _tipPercentage,
                        min: 0,
                        max: 30,
                        divisions: 6,
                        label: '${_tipPercentage.toInt()}%',
                        onChanged: (val) {
                          setState(() {
                            _tipPercentage = val;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [0, 5, 10, 15, 20, 25, 30].map((rate) {
                          final isSelected = _tipPercentage.toInt() == rate;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _tipPercentage = rate.toDouble();
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Text(
                                '$rate%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Input: Number of People Splitting
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Split Between',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_splitCount ${_splitCount == 1 ? "Person" : "People"}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: _splitCount > 1
                            ? () {
                                setState(() {
                                  _splitCount--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_splitCount',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () {
                          setState(() {
                            _splitCount++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

