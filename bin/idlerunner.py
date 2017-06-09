#!/usr/bin/env python3

import argparse
import datetime
import locale
import os
import signal
import subprocess
import sys
import time

self_name = sys.argv[0]

def main():
	global self_name

	parser = argparse.ArgumentParser(description="Run a program when the system is otherwise idle")
	parser.add_argument('-i', '--idle', type=int, default=80, help="CPU idle %% to trigger running of the program (default %(default)s)")
	parser.add_argument('-p', '--pid',  type=int, default=None, help="PID of the program to control")
	parser.add_argument('-d', '--delay', type=float, default=0.1, help="Delay between checks (default %(default)s)")
	parser.add_argument('-v', '--verbose', action='count', help="Be verbose. Duplicate for extra verbosity")
	parser.add_argument('command', nargs=argparse.REMAINDER)

	args = parser.parse_args(sys.argv[1:])
	self_name = parser.prog

	locale.setlocale(locale.LC_ALL, '')

	if args.pid is None:
		if len(args.command) == 0:
			log("Please either specify a PID or a command to run")
			sys.exit(1)

		sub = subprocess.Popen(args.command)
		pid = sub.pid
	else:
		pid = args.pid

	idle_threshold = args.idle / 100
	sleep_time = args.delay
	verbosity = 0 if args.verbose is None else args.verbose

	user_hz = get_user_hz()
	cpu_count = get_cpu_count()

	try:
		idle_last = get_idle()
		proc_last = get_proc_cpu(pid)
	except FileNotFoundError:
		if verbosity >= 1:
			log("Process died, exiting")
		sys.exit(0)

	stopped = False

	if verbosity >= 2:
		log("proc  idle  total")

	while True:
		time.sleep(sleep_time)

		try:
			idle = get_idle()
			proc = get_proc_cpu(pid)
			idle_delta = idle - idle_last
			proc_delta = proc - proc_last
			idle_last = idle
			proc_last = proc
		except FileNotFoundError:
			if verbosity >= 1:
				log("Process died, exiting")
			sys.exit(0)

		idle_fraction = idle_delta / (sleep_time * user_hz * cpu_count)
		proc_fraction = proc_delta / (sleep_time * user_hz * cpu_count)
		total_fraction = idle_fraction + proc_fraction

		if verbosity >= 2:
			log("%.2f, %.2f, %.2f", proc_fraction, idle_fraction, total_fraction)

		if stopped:
			if idle_fraction >= idle_threshold:
				if verbosity >= 1:
					log("Idle %% (%d) above threshold, starting process", round(idle_fraction * 100))
				start_proc(pid)
				stopped = False
		else:
			if total_fraction < idle_threshold:
				if verbosity >= 1:
					log("Idle + process %% (%d) below threshold, stopping process", round(total_fraction * 100))
				stop_proc(pid)
				stopped = True

def log(fmt, *args):
	global self_name
	datestr = datetime.datetime.now().strftime("%c")
	logstr = ("[%s] %s: " + fmt) % ((datestr, self_name) + args)
	print(logstr, file=sys.stderr)

def get_user_hz():
	return os.sysconf(os.sysconf_names['SC_CLK_TCK'])

def get_cpu_count():
	with open('/proc/stat', 'r') as f:
		return len(list(filter(lambda l: l.startswith('cpu'), f))) - 1

def get_idle():
	with open('/proc/stat', 'r') as f:
		cpu_count = 0
		for l in f:
			if l.startswith('cpu'):
				cs = l.split()
				if cs[0] == 'cpu':
					idle = int(cs[4])
		return idle

def get_proc_cpu(pid):
	with open('/proc/%d/stat' % (pid,), 'r') as f:
		cs = f.readline().split()
		return int(cs[13]) + int(cs[14])

def start_proc(pid):
	os.kill(pid, signal.SIGCONT)

def stop_proc(pid):
	os.kill(pid, signal.SIGSTOP)

if __name__ == '__main__':
	main()
