enum InvestmentCategory {
  environment,
  infrastructure,
  education,
  healthcare,
  industry,
}

class Investment {
  final String id;
  final String name;
  final String description;
  final double cost;
  final InvestmentCategory category;

  // Effects on world state per day after investment
  final double environmentDelta;
  final double industryDelta;
  final double happinessDelta;
  final int populationDelta;
  final int animalDelta;

  const Investment({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.category,
    this.environmentDelta = 0.0,
    this.industryDelta = 0.0,
    this.happinessDelta = 0.0,
    this.populationDelta = 0,
    this.animalDelta = 0,
  });
}

/// All available investments in the game.
const List<Investment> kAvailableInvestments = [
  Investment(
    id: 'solar_farm',
    name: 'Solarpark',
    description: 'Saubere Energie für die Region. Reduziert Industrie-Belastung.',
    cost: 200,
    category: InvestmentCategory.environment,
    environmentDelta: 0.05,
    industryDelta: -0.03,
    happinessDelta: 0.02,
    animalDelta: 3,
  ),
  Investment(
    id: 'nature_reserve',
    name: 'Naturschutzgebiet',
    description: 'Schützt Flora und Fauna. Vögel und Tiere kehren zurück.',
    cost: 300,
    category: InvestmentCategory.environment,
    environmentDelta: 0.08,
    industryDelta: -0.01,
    happinessDelta: 0.03,
    animalDelta: 10,
  ),
  Investment(
    id: 'factory',
    name: 'Fabrik',
    description: 'Schafft Arbeitsplätze, belastet aber die Umwelt.',
    cost: 400,
    category: InvestmentCategory.industry,
    environmentDelta: -0.06,
    industryDelta: 0.08,
    happinessDelta: 0.01,
    populationDelta: 5,
    animalDelta: -5,
  ),
  Investment(
    id: 'hospital',
    name: 'Krankenhaus',
    description: 'Verbessert die Lebensqualität und zieht neue Einwohner an.',
    cost: 350,
    category: InvestmentCategory.healthcare,
    happinessDelta: 0.06,
    populationDelta: 8,
  ),
  Investment(
    id: 'school',
    name: 'Schule',
    description: 'Bildung steigert langfristig das Glück der Bevölkerung.',
    cost: 250,
    category: InvestmentCategory.education,
    happinessDelta: 0.04,
    populationDelta: 3,
  ),
  Investment(
    id: 'park',
    name: 'Stadtpark',
    description: 'Grünfläche mitten in der Stadt. Tiere mögen es auch.',
    cost: 150,
    category: InvestmentCategory.environment,
    environmentDelta: 0.03,
    happinessDelta: 0.04,
    animalDelta: 4,
  ),
  Investment(
    id: 'wind_turbines',
    name: 'Windkraftanlage',
    description: 'Erzeugt Einnahmen und reduziert den CO₂-Ausstoß.',
    cost: 280,
    category: InvestmentCategory.environment,
    environmentDelta: 0.04,
    industryDelta: -0.02,
    happinessDelta: 0.01,
    animalDelta: 1,
  ),
  Investment(
    id: 'chemical_plant',
    name: 'Chemiewerk',
    description: 'Hohe Einnahmen, aber schwere Umweltschäden.',
    cost: 500,
    category: InvestmentCategory.industry,
    environmentDelta: -0.10,
    industryDelta: 0.12,
    happinessDelta: -0.02,
    animalDelta: -12,
  ),
];
