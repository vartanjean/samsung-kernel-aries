#@error.py
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
# (T.S / T.B / Trae32566 / Trae Santiago

#Build errors
class BuildError:
    def __init__(self):
        print('\nBuild failed, please check log!')
        exit(1)

#File access issues
class FileAccessError:
    def __init__(self, fileName):
        print('\nLocked or non-existant file: ' + fileName)
        exit(2)

#Result out of bounds
class OutOfBoundsError:
    def __init__(self, varData, varName):
        print('\nVariable {0} out of bounds ({1})'.format(varName, varData))
        exit(3)
        
class UserSettingsError:
    def __init__(self, traceback):
        print('\nYour userSettings.xml file is improperly configured, please check {0}.'.format(traceback))
        exit(4)