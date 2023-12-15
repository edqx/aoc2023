import std/[os, strutils, sequtils]
echo (readFile paramStr 1).split(',').foldl(a + b.foldl(((a + ord(b)) * 17) mod 256, 0), 0)