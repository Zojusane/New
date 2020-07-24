# -*- coding: utf-8 -*-
"""
Created on Fri Jul 17 10:52:40 2020

@author: Administrator
"""

import re
from pyhanlp import*
def cutpieces(text):
    textlist=re.split(r'[。；！？]',text)
    java = JClass('com.hankcs.hanlp.dependency.nnparser.NeuralNetworkDependencyParser')
    segment =HanLP.newSegment('viterbi')
    textreal={}
    reali=-1
    for text2 in textlist:
        reali+=1
        textagain=text2.split('，')
        seg_result1 = segment.seg(text2)
        dp_result = java.compute(seg_result1)
        word_array = dp_result.getWordArray()
        againi=0
        textreal[reali]=textagain[againi]
        for i in range(len(word_array)):
            flagin=0
            flagout=0
#            result1 = [word_array[i].LEMMA, word_array[i].DEPREL, word_array[i].HEAD.LEMMA]
            if word_array[i].LEMMA=='，':
                flagout=1
                againi+=1
                for j in range(i+1,len(word_array)):
                    if word_array[j].DEPREL=='SBV' or (word_array[j].DEPREL=='POB' and word_array[j].HEAD.LEMMA=='被'):
                        reali+=1
                        textreal[reali]=textagain[againi]
                        flagin=1
                        break
                    if word_array[j].LEMMA=='，':
                        break
            if flagout==1 and flagin==0:
                textreal[reali]+='，'+textagain[againi]
            if flagout==0 and flagin==0:
                pass
    return textreal



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    