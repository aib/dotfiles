#!/usr/bin/env python3

import datetime
import fileinput
import locale
import sys

MYNAME = 'git-drop-commits.py'

locale.setlocale(locale.LC_ALL, '')

if len(sys.argv) != 2:
	print("Must specify commit hash list file as argument", file=sys.stderr)
	sys.exit(1)

with open(sys.argv[1]) as clistfile:
	clist = [f.strip() for f in clistfile.readlines()]

print('# File modified by', MYNAME, 'at', datetime.datetime.now().strftime('%c'))

for line in fileinput.input('-'):
	line = line.strip()

	if len(line) == 0 or line.startswith('#'):
		print(line)
		continue

	(action, chash, message) = line.split(maxsplit=2)

	if any(map(lambda h: h.startswith(chash), clist)):
		print('# ', line, sep='')
		print('drop', chash, message, '#', MYNAME)
	else:
		print(line)
