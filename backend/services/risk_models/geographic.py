from collections import Counter

def calculate_hhi(supplier_countries: list) -> dict:
    total = len(supplier_countries)
    if total == 0:
        return {'hhi_score': 0, 'risk_level': 'LOW'}
    country_counts = Counter(supplier_countries)

    hhi = sum((count / total) ** 2 for count in country_counts.values())

    dominant = {c: count/total for c, count in country_counts.items() if count/total > 0.3}
    
    diversification_advice = 'Consider diversifying'
    if hhi <= 0.25:
        diversification_advice = 'Well diversified'

    return {
        'hhi_score': round(hhi, 4),
        'risk_level': 'CRITICAL' if hhi > 0.40 else 'HIGH' if hhi > 0.25 else 'MEDIUM' if hhi > 0.15 else 'LOW',
        'dominant_regions': dominant,
        'diversification_advice': diversification_advice
    }
