import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'flashcards_page.dart';

class AISummaryPage extends StatefulWidget {
  const AISummaryPage({super.key});

  @override
  State<AISummaryPage> createState() => _AISummaryPageState();
}

class _AISummaryPageState extends State<AISummaryPage> {
  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.honeyDark)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summary', style: Theme.of(context).textTheme.headlineMedium),
                          Text("Newton's Laws of Motion", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border, color: AppColors.honeyDark)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.share, color: AppColors.honeyDark)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: Offset(0, 5))],
                          border: Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.summarize, color: AppColors.honeyDark),
                                SizedBox(width: 8),
                                Text('AI-Generated Summary', style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            SizedBox(height: 14),
                            Text(
                              "Newton's Laws of Motion are three fundamental physical laws that together laid the foundation for classical mechanics. They describe the relationship between a body, the forces acting upon it, and its resulting motion.",
                              style: TextStyle(color: AppColors.textPrimary, height: 1.7, fontSize: 14),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "These laws were first compiled by Sir Isaac Newton in his 1687 work 'Philosophiæ Naturalis Principia Mathematica' and are applied everyday in engineering, physics problems, and understanding how the physical world works.",
                              style: TextStyle(color: AppColors.textPrimary, height: 1.7, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Key Points', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18) ?? Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 12),
                      ...[
                        (Icons.looks_one, 'Law 1 - Inertia: Objects tend to maintain their state of motion unless acted upon by a net external force.'),
                        (Icons.looks_two, 'Law 2 - F = ma: Force equals mass times acceleration; defines how forces change motion.'),
                        (Icons.looks_3, 'Law 3 - Equal & Opposite: Every action force has an equal and opposite reaction force.'),
                        (Icons.auto_graph, 'Applications: Engineering design, projectile motion, orbits, friction analysis, collisions.'),
                      ].map((t) => Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.cardWhite,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(t.$1, color: AppColors.honeyDark, size: 22),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(t.$2, style: TextStyle(color: AppColors.textPrimary, height: 1.5, fontSize: 13)),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      SizedBox(height: 20),
                      Text('Important Terms', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 12),
                      DataTable(
                        columnSpacing: 14,
                        horizontalMargin: 0,
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5)),
                        ),
                        columns: [
                          DataColumn(label: Text('Term', style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Definition', style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold))),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Force', style: TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('A push or pull; vector quantity (N)', style: TextStyle(fontSize: 12))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Mass', style: TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('Amount of matter; constant (kg)', style: TextStyle(fontSize: 12))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Weight', style: TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('Force of gravity on mass (W = mg)', style: TextStyle(fontSize: 12))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Acceleration', style: TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('Rate of velocity change (m/s²)', style: TextStyle(fontSize: 12))),
                          ]),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              text: 'Simplify',
                              icon: Icons.compress,
                              fullWidth: true,
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Explain More',
                              icon: Icons.unfold_more,
                              fullWidth: true,
                              backgroundColor: AppColors.purpleAccent,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Quiz Me',
                              icon: Icons.quiz,
                              fullWidth: true,
                              backgroundColor: AppColors.successGreen,
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Flashcards',
                              icon: Icons.style,
                              fullWidth: true,
                              backgroundColor: AppColors.accentOrange,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardsPage()));
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: SecondaryButton(
                          text: 'Save Summary',
                          icon: Icons.save_alt,
                          fullWidth: false,
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 32),
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
}
