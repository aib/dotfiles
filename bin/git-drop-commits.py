#!/usr/bin/env python3

import datetime
import fileinput
import locale
import sys

MYNAME = 'git-drop-commits.py'

locale.setlocale(locale.LC_ALL, '')

if '-n' in sys.argv:
	sys.argv.remove('-n')
	negate = True
else:
	negate = False

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

	(action, chash, *opt_message) = line.split(maxsplit=2)
	message = opt_message[0] if len(opt_message) == 1 else ""

	if any(map(lambda h: h.startswith(chash), clist)) ^ negate:
		print('# ', line, sep='')
		print('drop', chash, message, '#', MYNAME)
	else:
		print(line)
