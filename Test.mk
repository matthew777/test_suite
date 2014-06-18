#
# PM-QA validation test suite for the power management on Linux
#
# Copyright (C) 2011, 2012, Linaro Limited.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# Contributors:
#     Daniel Lezcano <daniel.lezcano@linaro.org> (IBM Corporation)
#       - initial API and implementation
#
SNT=$(wildcard *sanity.sh)
TST=$(wildcard *[^(sanity)].sh)
LOG=$(TST:.sh=.log)
CFLAGS?=-g -Wall -pthread
CC?=$(CROSS_COMPILE)gcc
SRC=$(wildcard *.c)
EXEC=$(SRC:%.c=%)

run: run_tests

SANITY_STATUS:= $(shell if test $(SNT) && test -f $(SNT); then \
		./$(SNT); if test "$$?" -eq 0; then echo 0; else \
		echo 1; fi; else echo 1; fi)

ifeq "$(SANITY_STATUS)" "0"
run_tests: unrun $(EXEC) $(LOG)

%.log: %.sh
	@echo "###"
	@echo "### $(<:.sh=):"
	@echo -n "### "; cat $(<:.sh=.txt);
	@echo -n "### "; grep "URL :" ./$< | awk '/http/{print $$NF}'
	@echo "###"
	-@./$< 2> $@
else
run_tests: $(SNT)
	@cat $(<:.sh=.txt)
endif

unrun:
	-@test ! -z "$(LOG)" && rm -f $(LOG)

rerun: unrun run

clean:
	rm -f *.log
