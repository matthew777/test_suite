#
# Validation test suite for TI ARM features on Linux
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
#     Torez Smith <torez.smith@linaro.org> (IBM Corporation)
#       - initial API and implementation
#     David A. Long <dave.long@linaro.org>
#       - copied and modified for TI/OMAP-specific tests and utilities
#     Matthew Hong <matthew.hong@tw.fujitsu.com>
#       - copied for TI/OMAP-specific tests
#       - modified and added for Fujitsu tests
#

SUBDIRS = sd smc kernelbuild sdcard emmc usb usb_host_perf usb_dev_perf \
          cpu_nbench reboot hsspi

AUTORUNDIRS = sd smc kernelbuild sdcard emmc usb usb_host_perf \
          cpu_nbench

.PHONY: $(SUBDIRS)

.PHONY: $(AUTORUNDIRS)

.PHONY: all clean 

.PHONY: run unrun rerun

$(SUBDIRS):
	$(MAKE) -C $@ run

run:
	for dir in $(AUTORUNDIRS); do \
		$(MAKE) -C $$dir run; \
	done

unrun:
	for dir in $(AUTORUNDIRS); do \
		$(MAKE) -C $$dir unrun; \
	done

rerun: unrun run

clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

