#! /usr/bin/python2
# -*- coding: UTF-8 -*-
# File: PinyinSearch.py
# Date: Sun Sep 09 22:46:19 2012 +0800
# Author: Yuxin Wu <ppwwyyxxc@gmail.com>

import sys

ENCODING = 'utf8'

def pinyin_match(table, line, char):

    file = open(table, 'r')

    dict = {}
    map(lambda x: dict.__setitem__(x.split(' ')[0].decode(ENCODING),
                                   map(lambda u: u.strip(), x.split(' ')[1:])), file.readlines())

    lineList = list(line)
    charList = list(char)

    flag = r = 0
    for i in lineList:
        r += 1
        try:
            t = dict[i]
        except KeyError:
            t = i

        if charList[flag] in t:
            flag += 1
        elif charList[0] in t:
            flag = 1
        else:
            flag = 0

        if flag == len(charList):
            break

    if flag == 0:
        return -1
    else:
        return r - flag


if __name__ == '__main__':
    #fout = open('/home/wyx/.vim/out.txt', 'a')
    #fout.write(sys.argv[1] +  '   ' + sys.argv[2] + '\n')
    #fout.close()
    #sys.exit()
    line = sys.argv[2].decode(ENCODING)
    r = pinyin_match(sys.argv[1], line[1:], sys.argv[3].decode(ENCODING))
    if r < 0:
        #fout.write('exit')
        sys.exit()
    else:
        #fout.write('\<Right>' * r or '\<Esc>\n')
        sys.stdout.write('\<Right>' * (r + 1) or '\<Esc>')

