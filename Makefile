data-import:
	@echo 'importing data to neo4j'
	LOAD CSV WITH HEADERS  FROM "file:///hudong_pedia.csv" AS line  
	CREATE (p:HudongItem{title:line.title,image:line.image,detail:line.detail,url:line.url,openTypeList:line.openTypeList,baseInfoKeyList:line.baseInfoKeyList,baseInfoValueList:line.baseInfoValueList})  
	LOAD CSV WITH HEADERS  FROM "file:///hudong_pedia2.csv" AS line  
	CREATE (p:HudongItem{title:line.title,image:line.image,detail:line.detail,url:line.url,openTypeList:line.openTypeList,baseInfoKeyList:line.baseInfoKeyList,baseInfoValueList:line.baseInfoValueList})  
	CREATE CONSTRAINT ON (c:HudongItem)
	ASSERT c.title IS UNIQUE
	# step2
	# 导入新的节点
	LOAD CSV WITH HEADERS FROM "file:///new_node.csv" AS line
	CREATE (:NewNode { title: line.title })
	#添加索引
	CREATE CONSTRAINT ON (c:NewNode)
	ASSERT c.title IS UNIQUE
	#导入hudongItem和新加入节点之间的关系
	LOAD CSV  WITH HEADERS FROM "file:///wikidata_relation2.csv" AS line
	MATCH (entity1:HudongItem{title:line.HudongItem}) , (entity2:NewNode{title:line.NewNode})
	CREATE (entity1)-[:RELATION { type: line.relation }]->(entity2)
	LOAD CSV  WITH HEADERS FROM "file:///wikidata_relation.csv" AS line
	MATCH (entity1:HudongItem{title:line.HudongItem1}) , (entity2:HudongItem{title:line.HudongItem2})
	CREATE (entity1)-[:RELATION { type: line.relation }]->(entity2)
	# step3
	LOAD CSV WITH HEADERS FROM "file:///attributes.csv" AS line
	MATCH (entity1:HudongItem{title:line.Entity}), (entity2:HudongItem{title:line.Attribute})
	CREATE (entity1)-[:RELATION { type: line.AttributeName }]->(entity2);
	LOAD CSV WITH HEADERS FROM "file:///attributes.csv" AS line
	MATCH (entity1:HudongItem{title:line.Entity}), (entity2:NewNode{title:line.Attribute})
	CREATE (entity1)-[:RELATION { type: line.AttributeName }]->(entity2);
	LOAD CSV WITH HEADERS FROM "file:///attributes.csv" AS line
	MATCH (entity1:NewNode{title:line.Entity}), (entity2:NewNode{title:line.Attribute})
	CREATE (entity1)-[:RELATION { type: line.AttributeName }]->(entity2);
	LOAD CSV WITH HEADERS FROM "file:///attributes.csv" AS line
	MATCH (entity1:NewNode{title:line.Entity}), (entity2:HudongItem{title:line.Attribute})
	CREATE (entity1)-[:RELATION { type: line.AttributeName }]->(entity2)  
