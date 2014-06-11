#!/bin/bash
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
#     David A. Long <dave.long@linaro.org>
#	- Removed uneeded functions
#

TEST_NAME="$(basename ${0%.sh})"

log_begin() {
    printf "%-76s" "${TEST_NAME}: ${@}... "
}

log_end() {
    printf "$*\n"
}

log_skip() {
    log_begin "${@}"
    log_end "skip"
}

check() {

    local descr="${1}"
    local func="${2}"
    shift 2;

    log_begin "checking ${descr}"

    $func "${@}"
    if [ "${?}" != 0 ]; then
	log_end "fail"
	return 1
    fi

    log_end "pass"

    return 0
}

check_file() {
    local file="${1}"
    local dir="${2}"

    check "${file} exists" "test -f" "${dir}/${file}"
}
