from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from dependencies.auth import require_role, CurrentUser
from database import get_db
import os
from neo4j import AsyncGraphDatabase

router = APIRouter()

# Get neo4j connection details, handle absence gracefully
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD", "password")

@router.get("/graph")
async def get_network_graph(current_user: CurrentUser = Depends(require_role(["admin", "customer", "supplier"]))):
    """
    Returns the network graph for the supply chain.
    """
    try:
        driver = AsyncGraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        
        nodes = []
        edges = []
        
        async with driver.session() as session:
            result = await session.run(
                "MATCH (n) RETURN n.name AS id, labels(n)[0] AS label, n.risk_score AS risk_score"
            )
            async for record in result:
                nodes.append({"id": record["id"], "label": record["label"], "risk_score": record["risk_score"]})
                
            res_edges = await session.run(
                "MATCH (a)-[r]->(b) RETURN a.name AS src, b.name AS dst, type(r) AS type, r.criticality AS crit, r.lead_time_days AS lead_time"
            )
            async for edge in res_edges:
                edges.append({
                    "source": edge["src"],
                    "target": edge["dst"],
                    "type": edge["type"],
                    "criticality": edge["crit"],
                    "lead_time": edge["lead_time"]
                })
        
        await driver.close()
        return {"nodes": nodes, "edges": edges}
    except Exception as e:
        return {"error": str(e), "message": "Failed to connect to Neo4j. Check your environment configuration."}

@router.get("/spof-analysis")
async def spof_analysis(current_user: CurrentUser = Depends(require_role(["admin", "customer"]))):
    """
    Calculates SPOF based on betweenness centrality.
    """
    try:
        from services.risk_models.spof import calculate_spof_scores
        driver = AsyncGraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        spof_nodes = await calculate_spof_scores(driver)
        await driver.close()
        
        # In a real app we'd save results to PostgreSQL here
        
        return spof_nodes
    except Exception as e:
        return {"error": str(e), "message": "Failed to calculate SPOF scores."}

@router.get("/resilience")
async def network_resilience(
    current_user: CurrentUser = Depends(require_role(["admin", "customer"])),
    db: Session = Depends(get_db)
):
    """
    Calculates overall network resilience score.
    (Mocked for now since PostgreSQL has no node_risk column yet).
    """
    # Placeholder: fetch nodes and 1 - (sum / count)
    return {
        "network_resilience_score": 0.72,
        "trend": "down",
        "timestamp": "2026-03-08T13:31:17Z"
    }
