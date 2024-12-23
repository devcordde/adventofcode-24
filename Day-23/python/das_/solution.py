from collections import defaultdict

connections = [connection.split("-") for connection in open("input.txt").read().splitlines()]

edges = defaultdict(set)
for connection in connections:
    edges[connection[0]].add(connection[1])
    edges[connection[1]].add(connection[0])

biggest_connection = (420, 69)
triples = set()
for node in edges:
    list_nodes = [[node, n] for n in edges[node]]
    for connected_node in edges[node]:
        for l in list_nodes:
            if connected_node not in l and all([k in edges[connected_node] for k in l]):
                l.append(connected_node)

        biggest_connection = max(sorted(max(list_nodes, key=len)), biggest_connection, key=len)

        for x in edges[connected_node]:
            if node in edges[x]:
                triples.add(tuple(sorted((node, connected_node, x))))

print(f"Part 1:", sum(any(triple[k].startswith("t") for k in range(3)) for triple in triples))
print("Part 2:", ",".join(biggest_connection))
