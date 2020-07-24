# -*- coding: utf-8 -*-
"""
Created on Sat Jun 20 22:13:57 2020

@author: Administrator
"""

import jieba  
import xlrd
from datetime import date,datetime
import xdrlib,sys  
import xlwt  
import jieba.posseg
import jieba.analyse 
from py2neo import Graph,Node,Relationship

node4news=[]

def read_excel():
    neog = Graph('http://localhost:7474',username = 'neo4j',password = '15629080992')
    data =xlrd.open_workbook(r'C:\Users\Administrator\Desktop\the first.xlsx')
 
#    file = xlwt.Workbook()
#    table_w = file.add_sheet('fc',cell_overwrite_ok=True)
 
    table = data.sheet_by_index(0) 
    nrows = table.nrows 
    ncols = table.ncols
    num=0
    result={}
    key_list={}
    for i in range(nrows):
        if i > 0 :
            seg_list = jieba.posseg.cut(str(table.row(i)[1].value))
            jieba.analyse.set_stop_words(r'C:\Users\Administrator\Desktop\baidu_stopwords.txt')
            key_list[num] = jieba.analyse.extract_tags(str(table.row(i)[1].value),topK=30,withWeight=False,allowPOS=('n','nr','nrj','nrf','ns','nsf','nt','nz','nl','ng')) 
#            print (table.row(i)[1].value) 
            output=''
            for x in list(seg_list):
                output+="{}/{},".format(x.word,x.flag)
#                table_w.write(i,0,table.row_values(i)[0]) 
#                table_w.write(i,1,table.row_values(i)[1]) 
#                table_w.write(i,2,output) 
                j=3
                for tag in key_list[num]:
#                    table_w.write(i,j,tag) 
                    if tag in result:
                        result[tag]+=1
                    else:
                        result[tag]=1
                    j=j+1
            num+=1
#        else :
#            table_w.write(0,0,"文件名") 
#            table_w.write(0,1,"原词") 
#            table_w.write(0,2,"分词结果")
    result=sorted(result.items(),key=lambda kv:(kv[1],kv[0]),reverse=True)
    result=result[0:150]
    num2=0
    word={}
    suma={}
    for key,value in result:
        word[num2]=key
        num2 +=1
    for key in key_list:
        for i in range(0,150):
            for j in range(i+1,150):
                index=word[i],word[j]
                if word[i] in key_list[key]:
                    if word[j] in key_list[key]:
                        if index in suma:
                            suma[index]+=1
                        else:
                            suma[index]=1
    suma=sorted(suma.items(),key=lambda kv:(kv[1],kv[0]),reverse=True)
    suma=suma[0:800]
    node_list=[]
    for key,value in suma:
        if key[0] in node4news:
            pass
        else:
            node4news.append(key[0])
        if key[1] in node4news:
            pass
        else:
            node4news.append(key[1])
    for node_name in node4news:
        node=Node(node_name,name=node_name)
        neog.create(node)
        node_list.append(node)
    for i in range(0,len(node4news)):
        for j in range(i+1,len(node4news)):
            for key,value in suma:
                if node4news[i]==key[0]:
                    if node4news[j]==key[1]:
                        r=Relationship(node_list[i],str(value),node_list[j])
                        neog.create(r)
                        break
                if node4news[i]==key[1]:
                    if node4news[j]==key[0]:
                        r=Relationship(node_list[j],str(value),node_list[i])
                        neog.create(r)
                        break                

            
    

            
        
#    file.save(r'C:\Users\Administrator\Desktop\source_files_fc.xls')
 
 
read_excel()