# -*- coding: utf-8 -*-
"""
Created on Fri Jul 17 11:27:50 2020

@author: Administrator
"""

import re
from pyhanlp import*
def triplegnrt(text):
    java = JClass('com.hankcs.hanlp.dependency.nnparser.NeuralNetworkDependencyParser')
    segment =HanLP.newSegment('viterbi')
    seg_result1 = segment.seg(text)
    dp_result = java.compute(seg_result1)
    word_array = dp_result.getWordArray()
    double=[]
    flagbei=1
    flagba=1
    subjec=[]
    objec=[]
    relation=[]
    subj=''
    rela=''
    obj=''
    flagsbv=0
    for word in word_array:
        double.append([word.LEMMA, word.DEPREL, word.HEAD.LEMMA, word.POSTAG])
#    print(double)
    for word in word_array:
        if word.DEPREL=='SBV' and flagsbv==0:
            subj=word.LEMMA
            subjec.append(subj)
            flagbei=0
            flagsbv=1
            continue
        if word.DEPREL=='SBV' and flagsbv==1:
            obj=word.LEMMA
            objec.append(obj)
            continue
        if word.DEPREL=='VOB' :
#            if word.HEAD.LEMMA!=rela:
#                file_wrong.write('主谓宾错误：'+double+'\n')
#            else:
            obj=word.LEMMA
            objec.append(obj)
            rela=word.HEAD.LEMMA
            relation.append(rela)
            if flagbei==0:
                flagba=0   
    if flagbei==1:
        flagba=0
        for word in word_array:
            if word.HEAD.LEMMA =='被' and word.DEPREL=='POB':
                subj=word.LEMMA
                subjec.append(subj)
                break
        for word in word_array:
            if word.LEMMA=='被' and word.DEPREL=='ADV':
                rela=word.HEAD.LEMMA
                relation.append(rela)
                break
        for word in word_array:
            if word.DEPREL=='FOB' and word.HEAD.LEMMA==rela:
                obj=word.LEMMA
                objec.append(obj)
                break
    if flagba==1:
        for word in word_array:
            if word.DEPREL=='POB' and word.HEAD.LEMMA=='把':
                obj=word.LEMMA
                objec.append(obj)
                break
    if rela=='':
        for word in word_array:
            if word.DEPREL=='HED':
                rela=word.LEMMA
                relation.append(rela)
                break
    for word in word_array:
        if word.DEPREL=='COO':
            if word.HEAD.LEMMA==subj:
                subjec.append(word.LEMMA)
                continue
            if word.HEAD.LEMMA==rela:
                relation.append(word.LEMMA)
                continue
            if word.HEAD.LEMMA==obj:
                objec.append(word.LEMMA)
    for j in range(len(objec)):
        for i in range(len(word_array)-1,-1,-1):
            if word_array[i].DEPREL=='ATT' and word_array[i].HEAD.LEMMA in objec[j] and word_array[i].POSTAG!='a':
                objec[j]=word_array[i].LEMMA+objec[j]                        
    for j in range(len(relation)):
        for i in range(len(word_array)-1,-1,-1):
            if word_array[i].DEPREL=='ADV' and word_array[i].HEAD.LEMMA in relation[j]:
                if word_array[i].POSTAG!='pbei'and word_array[i].POSTAG!='pba':
                    relation[j]=word_array[i].LEMMA+relation[j]      
    for j in range(len(subjec)):
        for i in range(len(word_array)-1,-1,-1):
            if word_array[i].DEPREL=='ATT' and word_array[i].HEAD.LEMMA in subjec[j] and word_array[i].POSTAG!='a':
                subjec[j]=word_array[i].LEMMA+subjec[j]          
    relationship=''
    for revalue in relation:
        relationship+=revalue
    tupleList=[]
    for m in range(len(subjec)):
        for n in range(len(objec)):
            if subjec[m]!=objec[n]:
                tuple = (subjec[m],relationship,objec[n])
                tupleList.append(tuple)
#                print(tuple)
    return tupleList        
    
    
                
                
                
                
            
            
                
            
            
        
       
        
        
        
          
    
