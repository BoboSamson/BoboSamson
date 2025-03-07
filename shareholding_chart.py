import sys
import json
import networkx as nx
import matplotlib.pyplot as plt

# Read input arguments
input_file = sys.argv[1]
output_file = sys.argv[2]

# Load data from JSON file
with open(input_file, "r") as f:
    data = json.load(f)

G = nx.DiGraph()
pos = {}

# Extract companies and shareholders
companies = [company["name"] for company in data["companies"]]
shareholders = [sh["name"] for sh in data["shareHolders"]]

# Assign positions (companies at top, shareholders at bottom)
for i, company in enumerate(companies):
    pos[company] = (i, 2)  # Y=2 for companies
for i, shareholder in enumerate(shareholders):
    pos[shareholder] = (i, 0)  # Y=0 for shareholders

# Extract edges with shareholding values
edges = []
for shareholder in data["shareHolders"]:
    for company, shares in shareholder["holds"].items():
        edges.append((company, shareholder["name"], shares))

# Add nodes and edges to the graph
G.add_nodes_from(companies)
G.add_nodes_from(shareholders)
for company, shareholder, shares in edges:
    G.add_edge(company, shareholder, weight=shares)

# Draw the graph
plt.figure(figsize=(8, 6))
nx.draw_networkx_nodes(G, pos, nodelist=companies, node_color="lightblue", node_shape="s", node_size=2000)
nx.draw_networkx_nodes(G, pos, nodelist=shareholders, node_color="lightgray", node_shape="o", node_size=1500)
nx.draw_networkx_edges(G, pos, arrowstyle="->", arrowsize=15)
nx.draw_networkx_labels(G, pos, font_size=10, font_weight="bold")

# Draw edge labels (shareholding values)
edge_labels = {(u, v): f"{d['weight']}%" for u, v, d in G.edges(data=True)}
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=10)

plt.title("Shareholding Structure")
plt.axis("off")

# Save the figure
plt.savefig(output_file, format="png", dpi=300, bbox_inches="tight")
plt.show()

print(f"Graph saved as {output_file}")

