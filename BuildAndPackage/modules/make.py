#@make.py
#
# Copyright 2011 Trae Santiago
# ================================================
#
# This file is part of BuildAndPackage
#
# BuildAndPackage is free software: you 
# can redistribute it and/or modify it under the 
# terms of the GNU General Public License as 
# published by the Free Software Foundation, 
# either version 3 of the License, or (at your 
# option) any later version.
# 
# BuildAndPackage is distributed in the
# hope that it will be useful, but WITHOUT ANY 
# WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR 
# PURPOSE. See the GNU General Public License 
# for more details.
# 
# You should have received a copy of the GNU 
# General Public License along with BuildAndPackage. 
# If not, see: <http://www.gnu.org/licenses/>.
# (T.S / T.B / Trae32566 / Trae Santiago)

"""Module that makes the kernel

This module includes:
  o build(toolchain, log):
     Builds the kernel
     Returns a list of modules
     log (string -> file): Log file to write to
     toolchain (string -> directory with prefix): 
     Location of the toolchain to use

  o configure(defconfig, clean = False):
     Imports the defconfig and cleans if wanted
     Returns None
     defconfig (string -> device defconfig): Device 
     defconfig
     toolchain (string -> directory with prefix): 
     Location of the toolchain to use
     clean (int -> 0 - 2): Clean before make

  o revision():
     Gets Git revision (REQUIRES A TAG!)
     Returns revision number
"""

from subprocess import check_output

def build(log, toolchain):
    from error import BuildError
    from multiprocessing import cpu_count
    from subprocess import call, STDOUT

    #Write the ENTIRE build log to the file
    with open(log, 'w+') as buildLog:
        try: call(['ccache', 'make', 'ARCH=arm', 
                '-j' + str(cpu_count() + 1), 
                'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = buildLog)
        except CalledProcessError: 
            print('not using ccache...', end = '')
            try: call(['make', 'ARCH=arm', 
                    '-j' + str(cpu_count() + 1), 
                    'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = buildLog)
            except CalledProcessError: raise BuildError()

        #Error checking code & module finder
        buildLog.seek(0, 0)
        tempLog = buildLog.read()

        if tempLog.find('zImage is ready') == -1: raise BuildError()
        else:
            modules = list()
            startModule = tempLog[tempLog.find('  LD [M]  ') + 10
            while startModule != -1:
                module = tempLog[startModule: tempLog[startModule:].find('\n')]
                

def configure(defconfig, toolchain, clean = False):
    from error import OutOfBoundsError
    from os import sep
    from shutil import copyfile

    if not clean: pass
    elif clean == 1: check_output(['make', 'distclean', 'CROSS_COMPILE={0}'.format(toolchain)])
    elif clean == 2: check_output(['make', 'mrproper', 'CROSS_COMPILE={0}'.format(toolchain)])
    elif clean == 3: check_output(['make', 'clean', 'CROSS_COMPILE={0}'.format(toolchain)])
    else: raise OutOfBoundsError(clean , 'clean')

    check_output(['make', defconfig, 'ARCH=arm', 'CROSS_COMPILE={0}'.format(toolchain)])

def hoc(dirBAP, pkHeimdall):
    from os import sep

    check_output(['java', '-jar', '{0}{1}resources{1}binaries{1}One-Click-Packager2.jar'.format(dirBAP, sep), pkHeimdall])

def revision():
    revision = str(check_output(['git', 'describe']), 'UTF-8')
    return revision[6: revision[6:].find('-') + 6]