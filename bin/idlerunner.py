#!/usr/bin/env python3

import argparse
import os
import signal
import subprocess
import sys
import time

def main():
	parser = argparse.ArgumentParser(description="Run a program when the system is otherwise idle")
	parser.add_argument('-i', '--idle', type=int, default=80, help="CPU idle %% to trigger running of the program (default %(default)s)")
	parser.add_argument('-p', '--pid',  type=int, default=None, help="PID of the program to control")
	parser.add_argument('-d', '--delay', type=float, default=0.1, help="Delay between checks (default %(default)s)")
	parser.add_argument('-v', '--verbose', action='count', help="Be verbose. Duplicate for extra verbosity")
	parser.add_argument('command', nargs=argparse.REMAINDER)

	args = parser.parse_args()
	self_name = sys.argv[0]

	if args.pid is None:
		if len(args.command) == 0:
			print("Please either specify a PID or a command to run", file=sys.stderr)
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
			print("%s: Process died, exiting" % (self_name,), file=sys.stderr)
		sys.exit(0)

	stopped = False

	if verbosity >= 2:
		print("%s: proc  idle  total" % (self_name,), file=sys.stderr)

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
				print("%s: Process died, exiting" % (self_name,), file=sys.stderr)
			sys.exit(0)

		idle_fraction = idle_delta / (sleep_time * user_hz * cpu_count)
		proc_fraction = proc_delta / (sleep_time * user_hz * cpu_count)
		total_fraction = idle_fraction + proc_fraction

		if verbosity >= 2:
			print("%s: %.2f, %.2f, %.2f" % (self_name, proc_fraction, idle_fraction, total_fraction), file=sys.stderr)

		if stopped:
			if idle_fraction >= idle_threshold:
				if verbosity >= 1:
					print("%s: Idle %% (%d) above threshold, starting process"
						% (self_name, round(idle_fraction * 100)), file=sys.stderr)
				start_proc(pid)
				stopped = False
		else:
			if total_fraction < idle_threshold:
				if verbosity >= 1:
					print("%s: Idle + process %% (%d) below threshold, stopping process"
						% (self_name, round(total_fraction * 100)), file=sys.stderr)
				stop_proc(pid)
				stopped = True

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
