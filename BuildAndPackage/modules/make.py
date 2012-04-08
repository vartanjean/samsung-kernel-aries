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
  o build(log, toolchain):
     Builds the kernel
     Returns a list of modules, or none if they aren't found
     log (string -> file): Log file to write to
     toolchain (string -> directory with prefix): 
     Location of the toolchain to use

  o configure(defconfig, toolchain, clean = False):
     Imports the defconfig and cleans if wanted
     Returns None
     defconfig (string -> device defconfig): Device 
     defconfig
     toolchain (string -> directory with prefix): 
     Location of the toolchain to use
     clean (int -> 0 - 3): Clean before make

  o hoc(dirBAP, pkHeimdall):
     Creates a Heimdall One-Click package
     Returns None
     dirBAP (string -> directory): BuildAndPackage directory
     pkHeimdall (string -> file): Heimdall package

  o revision():
     Gets Git revision
     Returns revision number
"""

from subprocess import STDOUT, PIPE, Popen

def build(log, toolchain):
    from error import BuildError, FileAccessError
    from multiprocessing import cpu_count
    from subprocess import CalledProcessError

    #Build the kernel using ccache
    try: tempLog = str(Popen(['ccache', 'make', 'ARCH=arm', 
            '-j' + str(cpu_count() + 1), 
            'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = PIPE).communicate()[0], 'utf-8')
    #Can't find ccache, so build without
    except CalledProcessError: 
        print('not using ccache...', end = '')
        try: tempLog = str(Popen(['make', 'ARCH=arm', 
                '-j' + str(cpu_count() + 1), 
                'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = PIPE).communicate()[0], 'utf-8')
        except CalledProcessError: raise BuildError()

    #Error checking code
    if tempLog.find('zImage is ready') == -1: raise BuildError()
    #Module finding code    
    else:
        #Check if this build was from scratch (if it has modules)
        modules = list()
        endModule = tempLog.find('.ko') + 3

        #It's a clean build
        if endModule >= 3:
            try:
                with open(log, 'w+') as buildLog:
                    buildLog.write(tempLog)
            except IOError: raise FileAccessError(log)

        #If it's not a clean build, try finding the modules
        else:   
            try:
                with open(log, 'r') as buildLog:
                    tempLog = buildLog.read()
                    endModule = tempLog.find('.ko') + 3
            #The modules were not found
            except IOError:
                try: 
                    with open(log, 'w+') as buildLog:
                        buildLog.write(tempLog)
                        return None
                except IOError: raise FileAccessError(log)
        while endModule >= 3:
            startModule = -1 * tempLog[endModule::-1].find(' ') + 1 + endModule
            modules.append(tempLog[startModule:endModule])

            #Cut off the part we already searched and find again
            tempLog = tempLog[endModule:]
            endModule = tempLog.find('.ko') + 3

        return modules

def configure(defconfig, toolchain, clean = False):
    from error import OutOfBoundsError
    from os import sep
    from shutil import copyfile

    if not clean: pass
    elif clean == 1: Popen(['make', 'ARCH=arm', 'distclean', 'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = PIPE)
    elif clean == 2: Popen(['make', 'ARCH=arm', 'mrproper', 'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = PIPE)
    elif clean == 3: Popen(['make', 'ARCH=arm', 'clean', 'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = PIPE)
    else: raise OutOfBoundsError(clean , 'clean')

    Popen(['make', 'ARCH=arm', defconfig, 'CROSS_COMPILE={0}'.format(toolchain)], stderr = STDOUT, stdout = PIPE)

def hoc(dirBAP, pkHeimdall):
    from os import sep

    Popen(['java', '-jar', '{0}{1}resources{1}binaries{1}One-Click-Packager2.jar'.format(dirBAP, sep), pkHeimdall], stderr = STDOUT, stdout = PIPE)

def revision():
    return str(Popen(['wc', '-l'], stdin = Popen(['git', 'rev-list', '--all'], stdout=PIPE).stdout, stdout = PIPE).communicate()[0], 'utf-8')