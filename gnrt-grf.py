# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 14:21:54 2020

@author: Administrator
""" 
import xlrd
import cut
import triple
from py2neo import Graph,Node,Relationship

neog = Graph('http://localhost:7474',username = 'neo4j',password = '15629080992')
data = xlrd.open_workbook(r'C:\Users\Administrator\Desktop\the first.xlsx')
table = data.sheet_by_index(0) 
nrows = table.nrows 
CutList = {}
tupleList=[]
nodeDict=[]
relationDict=[]
for i in range(nrows):
    if i > 0:
        CutList = cut.cutpieces(table.row(i)[1].value)
        print(CutList)
        for i in range(len(CutList)):
            tupleList = triple.triplegnrt(CutList[i])
            print(tupleList)
#            for m in range(len(tupleList)):
#                tuple = tupleList[m]
#                if tuple[0] in nodeDict:
#                    node1 = nodeDict[tuple[0]]
#                else:
#                    node1 = Node('node', name=tuple[0])
#                    nodeDict[tuple[0]] = node1
#                if tuple[2] in nodeDict:
#                    node2 = nodeDict[tuple[2]]
#                else:
#                    node2 = Node('node', name=tuple[2])
#                    nodeDict[tuple[2]] = node2
#                #这里的判断有待商榷，因为两个实体之间的关系很多，不应只建立一种关系
#                if tuple[0]+"+"+tuple[2] in relationDict:
#                    pass
#                else:
#                    relation = Relationship(node1, tuple[1], node2)
#                    relationDict[tuple[0] + "+" + tuple[2]] = relation
#                    s = node1 | relation | node2
#                    neog.create(s)
        