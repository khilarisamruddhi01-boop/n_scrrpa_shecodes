import networkx as nx
from neo4j import AsyncGraphDatabase

async def calculate_spof_scores(driver) -> dict:
    G = nx.DiGraph()
    async with driver.session() as session:
        result = await session.run(
            "MATCH (a)-[r]->(b) RETURN a.name AS src, b.name AS dst, r.criticality AS crit"
        )
        async for record in result:
            crit = record['crit'] if record['crit'] else 'LOW'
            weight = {'HIGH': 3, 'MEDIUM': 2, 'LOW': 1}.get(crit, 1)
            G.add_edge(record['src'], record['dst'], weight=weight)

    centrality = nx.betweenness_centrality(G, weight='weight', normalized=True)

    spof_nodes = {
        node: {'centrality': score, 'is_spof': score > 0.4, 'spof_tier': classify(score)}
        for node, score in centrality.items()
    }
    return spof_nodes

def classify(score: float) -> str:
    if score > 0.6: return 'CRITICAL_SPOF'
    if score > 0.4: return 'HIGH_SPOF'
    if score > 0.2: return 'MEDIUM_SPOF'
    return 'NO_SPOF'
